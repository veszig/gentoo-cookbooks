include_recipe "openssl::host_cert"
include_recipe "gentoo::portage"

gentoo_package_keywords "=www-servers/nginx-0.8.38-r1"
gentoo_package_keywords "=app-vim/nginx-syntax-0.3.1" if node.recipe?("vim")

nginx_modules = [
  "access", "auth_basic", "autoindex", "browser", "charset", "empty_gif",
  "gzip", "limit_req", "limit_zone", "map", "proxy", "referer", "rewrite",
  "upstream_ip_hash", "userid"
]

if %w(yes true on 1).include?(node[:nginx][:fcgi_php].to_s)
  nginx_modules << "fastcgi"

  node[:php][:cgi] = true
  include_recipe "php"

  gentoo_package_keywords "=www-servers/spawn-fcgi-1.6.3"

  package "www-servers/spawn-fcgi" do
    action :upgrade
  end

  cookbook_file "/etc/conf.d/spawn-fcgi.php" do
    source "spawn-fcgi.php.confd"
    owner "root"
    group "root"
    mode "0600"
  end

  link "/etc/init.d/spawn-fcgi.php" do
    to "/etc/init.d/spawn-fcgi"
  end
end

if %w(yes true on 1).include?(node[:nginx][:passenger].to_s)
  nginx_modules << "passenger"
end

current_modules = (node[:gentoo][:use_expands][:nginx_modules_http] || []).sort
unless current_modules == nginx_modules.sort
  node[:gentoo][:use_expands][:nginx_modules_http] = nginx_modules.sort
  generate_make_conf "NGINX_MODULES_HTTP changed"
end

gentoo_package_use "www-servers/nginx http http-cache pcre ssl"

package "www-servers/nginx" do
  action :upgrade
end

group "ssl" do
  members ["nginx"]
  append true
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "nginx"
  mode "0640"
  variables(
    :worker_processes => node[:nginx][:worker_processes],
    :worker_connections => node[:nginx][:worker_connections],
    :keepalive_timeout => node[:nginx][:keepalive_timeout],
    :passenger => node[:nginx][:passenger]
  )
end

directory "/etc/nginx/vhosts.d" do
  owner "root"
  group "root"
  mode "0700"
end

directory "/var/www" do
  owner "root"
  group "root"
  mode "0755"
end

if %w(yes true on 1).include?(node[:nginx][:fcgi_php].to_s)
  service "spawn-fcgi.php" do
    supports :status => true, :restart => true
    action [ :enable, :start ]
    subscribes :restart, resources(:package => "www-servers/spawn-fcgi", :cookbook_file => "/etc/conf.d/spawn-fcgi.php")
  end
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
  subscribes :reload, resources(:template => "/etc/nginx/nginx.conf")
  subscribes :restart, resources(:package => "www-servers/nginx")
  unless node[:ssl][:self_signed_host_cert]
    subscribes :reload, resources(:cookbook_file => "/etc/ssl/private/#{node[:fqdn]}.pem", :cookbook_file => "/etc/ssl/private/#{node[:fqdn]}.key")
  end
end

if node.recipe?("logrotate")
  directory "/var/log/nginx/old" do
    owner "root"
    group "root"
    mode "0700"
  end

  logrotate_config "nginx"
end

if node.recipe?("iptables")
  iptables_rule "nginx" do
    variables(:ports => [node[:nginx][:ports]].flatten)
  end
end

if node.recipe?("monit")
  monit_check "nginx" do
    variables(:ports => [node[:nginx][:ports]].flatten)
  end
end

if node.recipe?("nagios::nrpe")
  nrpe_command "nginx" do
    # master + workers
    variables(:processes => 1+node[:nginx][:worker_processes].to_i)
  end
end
