include_recipe "chef::client"
include_recipe "couchdb"
include_recipe "rabbitmq"

gentoo_package_keywords "=app-admin/chef-server-0.9.0"
gentoo_package_keywords "=app-admin/chef-server-api-0.9.0"
gentoo_package_keywords "=app-admin/chef-server-webui-0.9.0"
gentoo_package_keywords "=app-admin/chef-solr-0.9.0"
gentoo_package_keywords "=dev-ruby/bundler-0.9.26"
gentoo_package_keywords "=dev-ruby/coderay-0.9.3"
gentoo_package_keywords "=dev-ruby/daemons-1.0.10-r1"
gentoo_package_keywords "=dev-ruby/eventmachine-0.12.10-r2"
gentoo_package_keywords "=dev-ruby/haml-2.2.24"
gentoo_package_keywords "=dev-ruby/hpricot-0.8.2-r1"
gentoo_package_keywords "=dev-ruby/libxml-1.1.4"
gentoo_package_keywords "=dev-ruby/merb-assets-1.1.2"
gentoo_package_keywords "=dev-ruby/merb-core-1.1.2"
gentoo_package_keywords "=dev-ruby/merb-haml-1.1.2"
gentoo_package_keywords "=dev-ruby/merb-helpers-1.1.2"
gentoo_package_keywords "=dev-ruby/merb-param-protection-1.1.2"
gentoo_package_keywords "=dev-ruby/merb-slices-1.1.2"
gentoo_package_keywords "=dev-ruby/rack-1.1.0"
gentoo_package_keywords "=dev-ruby/rake-0.8.7-r5"
gentoo_package_keywords "=dev-ruby/rake-compiler-0.7.0-r1"
gentoo_package_keywords "=dev-ruby/ruby-openid-2.1.7-r1"
gentoo_package_keywords "=www-servers/thin-1.2.5-r1"

refresh_required = false

# for virtual/jdk
if (%w(dlj-1.1 *) & [node[:gentoo][:accept_licenses]].flatten).empty?
  node[:gentoo][:accept_licenses] << "dlj-1.1"
  refresh_required = true
end

if refresh_required
  generate_make_conf "added chef requirements"
end

# TODO run these in bootstrap mode
# execute "/usr/bin/rabbitmqctl add_vhost /chef" do
#   not_if "/usr/bin/rabbitmqctl list_vhosts | grep ^/chef$"
#   ignore_failure true
# end
#
# execute "/usr/bin/rabbitmqctl add_user chef" do
#   command "/usr/bin/rabbitmqctl add_user chef #{node[:chef][:server][:amqp_pass]}"
#   not_if "/usr/bin/rabbitmqctl list_users | grep ^chef$"
#   ignore_failure true
# end
#
# execute '/usr/bin/rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"' do
#   not_if "/usr/bin/rabbitmqctl list_user_permissions chef | grep ^/chef"
#   ignore_failure true
# end

%w(chef-solr chef-server-api chef-server).each { |p|
  package "app-admin/#{p}" do
    action :upgrade
  end
}

%w(server solr).each { |s|
  template "/etc/chef/#{s}.rb" do
    source "#{s}.rb.erb"
    owner "chef"
    group "chef"
    mode "0600"
    variables(
      :amqp_pass => node[:chef][:server][:amqp_pass],
      :syslog => node[:chef][:syslog]
    )
  end
}

%w(checksums sandboxes).each { |d|
  directory "/var/lib/chef/#{d}" do
    owner "chef"
    group "chef"
    mode "0770"
  end
}

%w(chef-solr chef-solr-indexer).each { |s|
  service s do
    supports :status => true, :restart => true
    action [ :enable, :start ]
    subscribes :restart, resources(:package => "app-admin/chef-solr", :template => "/etc/chef/solr.rb")
  end
}

service "chef-server-api" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, resources(:package => "app-admin/chef-server-api", :template => "/etc/chef/server.rb")
end

http_request "compact chef couchDB" do
  action :post
  url "#{Chef::Config[:couchdb_url]}/chef/_compact"
  only_if do
    begin
      open("#{Chef::Config[:couchdb_url]}/chef")
      JSON::parse(open("#{Chef::Config[:couchdb_url]}/chef").read)["disk_size"] > 100_000_000
    rescue OpenURI::HTTPError
      nil
    end
  end
end

%w(nodes roles registrations clients data_bags data_bag_items users).each do |view|
  http_request "compact chef couchDB view #{view}" do
    action :post
    url "#{Chef::Config[:couchdb_url]}/chef/_compact/#{view}"
    only_if do
      begin
        open("#{Chef::Config[:couchdb_url]}/chef/_design/#{view}/_info")
        JSON::parse(open("#{Chef::Config[:couchdb_url]}/chef/_design/#{view}/_info").read)["view_index"]["disk_size"] > 100_000_000
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end

if node.recipe?("iptables")
  iptables_rule "chef-server" do
    action node.recipe?("chef::server_proxy") ? :delete : :create
  end
end

if node.recipe?("monit")
  %w(server solr).each { |s| monit_check "chef-#{s}" }
end

if node.recipe?("nagios::nrpe")
  nrpe_command "chef-server"
  nrpe_command "chef-solr"
end
