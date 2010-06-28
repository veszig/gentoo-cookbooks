include_recipe "gentoo::portage"
include_recipe "chef::overlay"

gentoo_package_keywords "=app-admin/chef-0.9.0"
gentoo_package_keywords "=dev-ruby/abstract-1.0.0"
gentoo_package_keywords "=dev-ruby/bunny-0.6.0"
gentoo_package_keywords "=dev-ruby/erubis-2.6.5"
gentoo_package_keywords "=dev-ruby/extlib-0.9.15"
gentoo_package_keywords "=dev-ruby/highline-1.5.2-r1"
gentoo_package_keywords "=dev-ruby/mime-types-1.16-r2"
gentoo_package_keywords "=dev-ruby/mixlib-authentication-1.1.2"
gentoo_package_keywords "=dev-ruby/mixlib-cli-1.2.0"
gentoo_package_keywords "=dev-ruby/mixlib-config-1.1.2"
gentoo_package_keywords "=dev-ruby/mixlib-log-1.1.0"
gentoo_package_keywords "=dev-ruby/moneta-0.6.0"
gentoo_package_keywords "=dev-ruby/ohai-0.5.6"
gentoo_package_keywords "=dev-ruby/rest-client-1.5.1"
gentoo_package_keywords "=dev-ruby/rubygems-1.3.7-r1"
gentoo_package_keywords "=dev-ruby/systemu-1.2.0"
gentoo_package_keywords "=dev-ruby/uuidtools-2.1.1-r1"

package "app-admin/chef" do
  action :upgrade
end

if node.run_list?("recipe[chef::server]")
  node[:chef][:client][:server_url] = "http://127.0.0.1:4000"
else
  file "/etc/chef/validation.pem" do
    action :delete
    backup false
    only_if { File.size?("/etc/chef/client.pem") }
  end
end

if %w(yes true on 1).include?(node[:chef][:syslog].to_s)
  gentoo_package "dev-ruby/SyslogLogger" do
    action :upgrade
    keywords "=dev-ruby/SyslogLogger-1.4.0"
  end
elsif node.run_list?("recipe[logrotate]")
  # TODO eliminate copytuncate http://tickets.opscode.com/browse/CHEF-1116
  logrotate_config "chef"
end

ruby_block "reload_client_config" do
  block do
    Chef::Config.from_file("/etc/chef/client.rb")
  end
  action :nothing
end

template "/etc/chef/client.rb" do
  source "client.rb.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :chef_server_url => node[:chef][:client][:server_url],
    :syslog => node[:chef][:syslog]
  )
  notifies :create, resources(:ruby_block => "reload_client_config")
end

service "chef-client" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, resources(:package => "app-admin/chef")
end

directory "/var/lib/chef/cache" do
  owner "root"
  group node.run_list?("recipe[chef::server]") ? "chef" : "root"
  mode "0770"
end

file "/var/log/chef/client.log" do
  owner "root"
  group "root"
  mode "0600"
  only_if { File.size?("/var/log/chef/client.log") }
end

if node.run_list?("recipe[monit]")
  monit_check "chef-client" do
    variables(:to => node[:monit][:alert_mail_to])
  end
end

if node.run_list?("recipe[nagios::nrpe]")
  nrpe_command "chef-client"
end
