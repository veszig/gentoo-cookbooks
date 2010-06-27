require "openssl"
require "fileutils"

module Opscode
  module Password
    def secure_random(length = 42)
      r = ""
      r << ::OpenSSL::Random.random_bytes(1).gsub(/\W/, '') while r.length < length
      r
    end

    def get_password(key, length = 42)

      #Chef::Log.debug("get_password called for key \"#{key}\" with password directory \"#{node[:password][:directory]}\"")

      # we don't persist the password if node[:password][:directory] is unset
      return secure_random(length) if node[:password][:directory].to_s == ""

      password_file = File.expand_path(
        key.gsub(/[^a-z0-9\.\-\_\/]/i, "_").sub(/^\.+/, '_'),
        node[:password][:directory]
      )

      #Chef::Log.debug("Password file for \"#{key}\" is \"#{password_file}\"")

      unless ::File.size?(password_file)
        dir = ::File.dirname(password_file)
        ::FileUtils.mkdir_p(dir, :mode => 0700) unless ::File.directory?(dir)
        password = secure_random(length)
        ::File.open(password_file, "w") { |f|
          f.chmod(0600)
          f << password + "\n" # for readability
        }
      end

      ::File.read(password_file).strip
    end
  end
end
