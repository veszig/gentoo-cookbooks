gentoo_package "net-firewall/iptables"

cookbook_file "/etc/conf.d/iptables" do
  source "iptables.confd"
  owner "root"
  group "root"
  mode "0600"
end

execute "rebuild-iptables" do
  command "/usr/local/sbin/rebuild-iptables"
  action :nothing
end

directory "/etc/iptables.d" do
  owner "root"
  group "root"
  mode "0700"
end

template "/usr/local/sbin/rebuild-iptables" do
  source "rebuild-iptables.rb.erb"
  owner "root"
  group "root"
  mode "0700"
  variables(:ulogd => node.recipe?("iptables::ulogd"))
end

iptables_rule "all_established"
iptables_rule "all_icmp"

execute "/usr/local/sbin/rebuild-iptables" do
  not_if { File.size?("/var/lib/iptables/rules-save") }
end

service "iptables" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
