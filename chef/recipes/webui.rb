gentoo_package_keywords "=app-admin/chef-server-webui-0.8.16"

package "app-admin/chef-server-webui" do
  action :upgrade
end

template "/etc/chef/webui.rb" do
  source "webui.rb.erb"
  owner "root"
  group "root"
  mode "0600"
  # TODO chef-webui may be on a different server than the chef-server
  variables(
    :chef_server_fqdn => "localhost",
    :syslog => node[:chef][:syslog]
  )
end

service "chef-server-webui" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, resources(:package => "app-admin/chef-server-webui", :template => "/etc/chef/webui.rb")
end

if node.recipe?("iptables")
  iptables_rule "chef-server-webui" do
    action node.recipe?("chef::webui_proxy") ? :delete : :create
  end
end

if node.recipe?("monit")
  monit_check "chef-server-webui"
end

if node.recipe?("nagios::nrpe")
  nrpe_command "chef-server-webui"
end
