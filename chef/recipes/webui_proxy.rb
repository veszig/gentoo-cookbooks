include_recipe "nginx"

unless node[:nginx][:ports].include?(node[:chef][:server][:webui_proxy_port])
  node[:nginx][:ports] << node[:chef][:server][:webui_proxy_port]
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

nginx_site "chef_webui_ssl_proxy" do
  docroot false
  template "nginx_webui_proxy.conf.erb"
  cookbook "chef"
  variables(:port => node[:chef][:server][:webui_proxy_port])
end
