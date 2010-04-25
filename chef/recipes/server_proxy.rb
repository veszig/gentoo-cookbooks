include_recipe "nginx"

unless node[:nginx][:ports].include?(node[:chef][:server][:server_proxy_port])
  node[:nginx][:ports] << node[:chef][:server][:server_proxy_port]
  if node.recipe?("iptables")
    iptables_rule "nginx" do
      cookbook "nginx"
      variables(:ports => [node[:nginx][:ports]].flatten)
    end
  end
  if node.recipe?("monit")
    monit_check "nginx" do
      cookbook "nginx"
      variables(:ports => [node[:nginx][:ports]].flatten)
    end
  end
end

nginx_site "chef_server_ssl_proxy" do
  docroot false
  template "nginx_server_proxy.conf.erb"
  cookbook "chef"
  variables(:port => node[:chef][:server][:server_proxy_port])
end
