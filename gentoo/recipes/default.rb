include_recipe "gentoo::portage"

template "/etc/conf.d/clock" do
  source "clock.confd.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :hwtimezone => node[:gentoo][:hwtimezone] == "UTC" ? "UTC" : "local",
    :timezone => node[:gentoo][:timezone],
    :synchwclock => node[:gentoo][:synchwclock]
  )
end

if File.exists?("/usr/share/zoneinfo/#{node[:gentoo][:timezone]}")
  link "/etc/localtime" do
    to "/usr/share/zoneinfo/#{node[:gentoo][:timezone]}"
  end
else
  Chef::Log.warn("Invalid timezone: \"#{node[:gentoo][:timezone]}\"")
end

template "/etc/conf.d/hostname" do
  source "hostname.confd.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:hostname => node[:hostname])
end

cookbook_file "/etc/securetty" do
  source "securetty"
  owner "root"
  group "root"
  mode "0600"
end

file "/etc/passwd" do
  owner "root"
  group "root"
  mode "0644"
end

file "/etc/shadow"do
  owner "root"
  group "root"
  mode "0600"
end

directory "/tmp" do
  owner "root"
  group "root"
  mode "1777"
end

execute "locale-gen" do
  command "/usr/sbin/locale-gen"
  action :nothing
end

template "/etc/locale.gen" do
  source "locale.gen.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:locales => node[:gentoo][:locales])
  notifies :run, resources(:execute => "locale-gen")
end

execute "sysctl_reload" do
  command "/sbin/sysctl -p /etc/sysctl.conf"
  action :nothing
end

template "/etc/sysctl.conf" do
  source "sysctl.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :hostname => node[:hostname],
    :domain => node[:domain],
    :sysctl_variables => node[:gentoo][:sysctl]
  )
  notifies :run, resources(:execute => "sysctl_reload")
end

# TODO test hardened configs
include_recipe "gentoo::hardened" if node[:gentoo][:profile] =~ /hardened/
