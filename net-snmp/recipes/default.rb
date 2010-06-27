include_recipe "gentoo::portage"

unless node[:gentoo][:use_flags].include?("snmp")
  node[:gentoo][:use_flags] << "snmp"
  generate_make_conf "added snmp USE flag"
end

gentoo_package_use "net-analyzer/net-snmp diskio"

package "net-analyzer/net-snmp" do
  action :upgrade
end

template "/etc/snmp/snmpd.conf" do
  source "snmpd.conf.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :monitoring_ips => [node[:snmpd][:monitoring_ips]].flatten,
    :community => node[:snmpd][:community],
    :syslocation => node[:snmpd][:syslocation],
    :syscontact => node[:snmpd][:syscontact],
    :execs => [node[:snmpd][:execs]].flatten,
    :disks => [node[:snmpd][:disks]].flatten
  )
end

cookbook_file "/etc/conf.d/snmpd" do
  source "snmpd.confd"
  owner "root"
  group "root"
  mode "0600"
end

service "snmpd" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  subscribes :reload, resources(:template => "/etc/snmp/snmpd.conf")
  subscribes :restart, resources(:package => "net-analyzer/net-snmp")
end

if node.recipe?("iptables")
  ips = [node[:snmpd][:monitoring_ips]].flatten.select { |i| i != "127.0.0.1" }
  iptables_rule "snmpd" do
    variables(:external_monitoring_ips => ips)
    action !ips.empty? ? :create : :delete
  end
end

if node.recipe?("monit")
  monit_check "snmpd"
end

if node.recipe?("nagios::nrpe")
  nrpe_command "snmpd"
end
