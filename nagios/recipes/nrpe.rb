gentoo_package "net-analyzer/nagios-plugins" do
  action :upgrade
  use node[:nagios][:nrpe][:use]
end

package "net-analyzer/nagios-nrpe" do
  action :upgrade
end

# on hardened systems only users in the wheel group are able to see other
# users' processes -- nagios needs to see them to be able to monitor them
if node.recipe?("gentoo::hardened")
  group "wheel" do
    members ["nagios"]
    append true
  end
end

directory "/etc/nagios/nrpe.d" do
  owner "root"
  group "nagios"
  mode "0750"
end

template "/etc/nagios/nrpe.cfg" do
  source "nrpe.cfg.erb"
  owner "root"
  group "nagios"
  mode "0640"
  variables(
    :monitoring_ips => [node[:nagios][:nrpe][:monitoring_ips]].flatten,
    :commands => node[:nagios][:nrpe][:commands]
  )
end

cookbook_file "/usr/local/sbin/nrpe_check_all_local" do
  source "nrpe_check_all_local.sh"
  owner "root"
  group "root"
  mode "0700"
end

service "nrpe" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  # subscribes :reload, resources(:template => "/etc/nagios/nrpe.cfg")
  subscribes :restart, resources(:package => "net-analyzer/nagios-nrpe")
end

nrpe_command "load"
nrpe_command "procs_default"
nrpe_command "time" do
  variables(:ntp_host => node[:ntpd][:pool] || "pool.ntp.org")
end

if node.recipe?("iptables")
  external_ips = [node[:nagios][:nrpe][:monitoring_ips]].flatten - ["127.0.0.1"]
  iptables_rule "nrpe" do
    variables(:ips => external_ips)
  end
end

if node.recipe?("monit")
end
