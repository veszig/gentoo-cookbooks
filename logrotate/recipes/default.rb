include_recipe "gentoo::portage"

unless node[:gentoo][:use_flags].include?("logrotate")
  node[:gentoo][:use_flags] << "logrotate"
  generate_make_conf "added logrotate USE flag"
end

gentoo_package "app-admin/logrotate"

directory "/etc/logrotate.d" do
  owner "root"
  group "root"
  mode "0700"
end

directory "/var/log/old" do
  owner "root"
  group "root"
  mode "0700"
end
