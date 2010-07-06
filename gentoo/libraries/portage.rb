# Based on chef and puppet's portage package provider.

module Opscode
  module Gentoo
    module Portage

      def unmerge(new_resource)
        package_data = eix_data(new_resource.name) || {}
        if package_data[:current_version].to_s != ""
          package_atom = "#{package_data[:category]}/#{package_data[:package_name]}"
          package_atom = "=#{package_atom}-#{new_resource.version}" if new_resource.version
          Chef::Log.info("Unmerging #{package_atom}.")
          Chef::Mixin::Command.run_command_with_systems_locale(
            :command => "emerge --unmerge --color n --nospinner --quiet #{new_resource.options} #{package_atom}"
          )
        end
      end

      # Creates or deletes per package portage attributes. Returns true if it
      # changes (sets or deletes) something.
      # * action == :create || action == :delete
      # * foo_category =~ /\A(use|keywords|mask|unmask)\Z/
      def manage_package_foo(action, foo_category, foo_data)
        foo_dir = "/etc/portage/package.#{foo_category}"

        if ::File.directory?(foo_dir)
          package_atom = foo_data.strip.split(/\s+/).first
          # =net-analyzer/nagios-core-3.1.2 => net-analyzer-nagios-core-3-1-2
          # =net-analyzer/netdiscover => net-analyzer-netdiscover
          package_file = package_atom.gsub(/[\/\.]/, "-").gsub(/[^a-z0-9_\-]/i, "")
          package_foo_path = "#{foo_dir}/#{package_file}"

          if action == :create
            if !::File.exists?(package_foo_path) || foo_data.strip != ::File.read(package_foo_path).strip
              ::File.open("#{package_foo_path}", "w") { |f| f << foo_data + "\n" }
              Chef::Log.info("Created package.#{foo_category} \"#{foo_data}\".")
              true
            end
          elsif action == :delete && ::File.exists?(package_foo_path)
            ::File.delete(package_foo_path)
            Chef::Log.info("Deleted package.#{foo_category} of \"#{package_atom}\".")
            true
          end

        else
          raise Chef::Exceptions::Package, "#{foo_dir} should be a directory."
        end
      end

      # Sets portage attributes and then emerges the package only if necessary.
      def conditional_emerge(new_resource, action)

        # Set package metadata that may influence our candidate search.
        %w(keywords mask unmask).each { |foo|
          if foo_data = new_resource.send(foo)
            manage_package_foo(:create, foo, foo_data)
          end
        }

        package_data = eix_data(new_resource.name) || {}
        if package_data[:candidate_version].to_s == ""
          raise Chef::Exceptions::Package, "No candidate version available for #{new_resource.name}"
        end

        package_atom = "#{package_data[:category]}/#{package_data[:package_name]}"
        package_atom = "=#{package_atom}-#{new_resource.version}" if new_resource.version

        if new_resource.use
          package_use = [package_atom, [new_resource.use]].flatten.join(" ")
          manage_package_foo(:create, "use", package_use)
        end

        if package_data[:current_version] == "" || action == :reinstall
          Chef::Log.info("Installing gentoo_package[#{package_atom}].")
          emerge(package_atom, new_resource.options)

        elsif new_resource.version.to_s != "" && package_data[:current_version] != new_resource.version
          Chef::Log.info("Installing gentoo_package[#{package_atom}] (version requirements unmet).")
          emerge(package_atom, new_resource.options)

        elsif action == :upgrade && package_data[:current_version] != package_data[:candidate_version]
          Chef::Log.info("Upgrading gentoo_package[#{package_atom}] from version #{package_data[:current_version]}.")
          emerge(package_atom, new_resource.options)
        end

      end

      private

      # Emerges "package_atom" with additional "options".
      def emerge(package_atom, options)
        emerge_command = [
          "/usr/bin/emerge --color n --nospinner -q", options, package_atom
        ].compact.join(" ")
        Chef::Mixin::Command.run_command_with_systems_locale(
          :command => emerge_command
        )
      end

      # Searches for "package_name" and returns a hash with parsed information
      # returned by eix.
      #
      #   # git is installed on the system
      #   eix_data("git")
      #   => {
      #        :category => "dev-vcs",
      #        :package_name => "git",
      #        :current_version => "1.6.3.3",
      #        :candidate_version => "1.6.4.4"
      #      }
      #   # git isn't installed
      #   eix_data("git")
      #   => {
      #        :category => "dev-vcs",
      #        :package_name => "git",
      #        :current_version => "",
      #        :candidate_version => "1.6.4.4"
      #      }
      #   eix_data("dev-vcs/git") == eix_data("git")
      #   => true
      #   eix_data("package/doesnotexist")
      #   => nil
      def eix_data(package_name)
        eix = "/usr/bin/eix"
        eix_update = "/usr/bin/eix-update"

        unless ::File.executable?(eix)
          raise Chef::Exceptions::Package, "You need app-portage/eix installed to use gentoo_package."
        end

        # We need to update the eix database if it's older than the current portage
        # tree or the eix binary.
        unless ::FileUtils.uptodate?("/var/cache/eix", [eix, "/usr/portage/metadata/timestamp"])
          Chef::Log.debug("Eix database outdated, calling `#{eix_update}`.")
          Chef::Mixin::Command.run_command_with_systems_locale(:command => eix_update)
        end

        query_command = [eix, "--nocolor", "--pure-packages", "--stable", "--exact",
          '--format "<category>\t<name>\t<installedversions:VERSION>\t<bestversion:VERSION>\n"',
          package_name.count("/") > 0 ? "--category-name" : "--name", package_name].join(" ")

        eix_out = eix_stderr = nil

        Chef::Log.debug("Calling `#{query_command}`.")
        status = Chef::Mixin::Command.popen4(query_command) { |pid,stdin,stdout,stderr|
          eix_out = if stdout.read.split("\n").first =~ /\A(\S+)\t(\S+)\t(\S*)\t(\S+)\Z/
            {
              :category => $1,
              :package_name => $2,
              :current_version => $3,
              :candidate_version => $4
            }
          end
          eix_stderr = stderr.read
        }

        eix_out ||= {}

        if status.exitstatus == 0
          Chef::Log.debug("Eix search for #{package_name} returned: category: \"#{eix_out[:category]}\", package_name: \"#{eix_out[:package_name]}\", current_version: \"#{eix_out[:current_version]}\", candidate_version: \"#{eix_out[:candidate_version]}\".")
        else
          raise Chef::Exceptions::Package, "Eix search failed: `#{query_command}`\n#{eix_stderr}\n#{status.inspect}!"
        end

        eix_out
      end
    end
  end
end
