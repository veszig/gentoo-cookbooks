include_recipe "eix"

link "/etc/make.profile" do
  to "../../usr/portage/profiles/#{node[:gentoo][:profile]}"
end

generate_make_conf "default"

directory "/etc/portage" do
  owner "root"
  group "portage"
  mode "0770"
end

directory "/var/log/portage" do
  owner "portage"
  group "portage"
  mode "2770"
end

directory "/var/log/portage/elog" do
  owner "portage"
  group "portage"
  mode "2770"
end

%w(keywords mask unmask use).each do |d|
  bash "convert_package_#{d}_to_file" do
    only_if { File.file?("/etc/portage/package.#{d}") }
    user "root"
    cwd "/etc/portage"
    code <<-EOC
    mv package.#{d} _package.#{d}
    mkdir package.#{d}
    sort -n _package.#{d} | uniq | egrep -v '^\s*(\#|$)' | while read LINE
    do
      echo "$LINE" > package.#{d}/$(echo ${LINE} | sed 's, .*$,,' | \
        sed 's,[\./],-,g' | sed -r 's,[^a-z0-9_\-],,g')
    done
    rm _package.#{d}
    EOC
  end

  directory "/etc/portage/package.#{d}" do
    owner "root"
    group "portage"
    mode "0770"
  end
end
