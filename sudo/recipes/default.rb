include_recipe "gentoo::portage"

gentoo_package "app-admin/sudo" do
  action :upgrade
  use %w(-ldap pam)
end

template "/etc/sudoers" do
  source "sudoers.erb"
  mode "0440"
  owner "root"
  group "root"
  variables(
    :sudoers_groups => node[:sudo][:groups],
    :sudoers_users => node[:sudo][:users],
    :sudoers_commands => node[:sudo][:commands]
  )
end

file "/bin/su" do
  owner "root"
  group "root"
  mode "4700"
end

file "/usr/bin/sudo" do
  owner "root"
  group "root"
  mode "4111"
end

file "/usr/bin/sudoedit" do
  owner "root"
  group "root"
  mode "4111"
end
