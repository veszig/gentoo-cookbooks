package "net-misc/openntpd" do
  action :upgrade
end

template "/etc/ntpd.conf" do
  source "ntpd.conf.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :listen_on => [node[:ntpd][:listen_on]].flatten,
    :pool => node[:ntpd][:pool]
  )
end

service "ntpd" do
  supports :status => true, :restart => true
  action [:enable, :start]
  subscribes :restart, resources(:package => "net-misc/openntpd", :template => "/etc/ntpd.conf")
end

if node.recipe?("iptables")
  iptables_rule "ntpd" do
    action node[:ntpd][:listen_on].empty? ? :delete : :create
  end
end

if node.recipe?("nagios::nrpe")
  nrpe_command "ntpd"
end
