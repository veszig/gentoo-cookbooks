#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Gábor Vészi <veszig@done.hu>
#
# Cookbook Name:: chef
# Recipe:: server
#
# Copyright 2009, Opscode, Inc.
# Copyright 2009, 37signals
# Copyright 2009, Gábor Vészi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'chef::client'
include_recipe 'couchdb'
include_recipe 'stompserver'

node[:apache][:ssl] = true
node[:apache][:listen_ports] << 444 unless node[:apache][:listen_ports].include?(444)

include_recipe 'apache2'
include_recipe 'apache2::passenger'

package_keyword '=app-admin/chef-server-0.7.10'
package_keyword '=app-admin/chef-server-slice-0.7.10'
package_keyword '=dev-ruby/eventmachine-0.12.8'
package_keyword '=dev-ruby/rcov-0.8.1.2.0'
package_keyword '=dev-ruby/ruby-ferret-0.11.6'
package_keyword '=dev-ruby/haml-2.2.3'
package_keyword '=dev-ruby/merb-assets-1.0.12'
package_keyword '=dev-ruby/merb-core-1.0.12'
package_keyword '=dev-ruby/merb-haml-1.0.12'
package_keyword '=dev-ruby/merb-helpers-1.0.12'
package_keyword '=dev-ruby/merb-slices-1.0.12'
package_keyword '=dev-ruby/mime-types-1.16-r1'
package_keyword '=dev-ruby/nokogiri-1.3.3'
package_keyword '=dev-ruby/rack-1.0.0'
package_keyword '=dev-ruby/stompserver-0.9.9'
package_keyword '=dev-ruby/thor-0.11.5'
package_keyword '=dev-ruby/webrat-0.5.3'

package 'app-admin/chef-server'

service 'chef-indexer' do
  action :nothing
end

template '/etc/chef/indexer.rb' do
  owner 'root'
  group 'root'
  mode 0600
  source 'indexer.rb.erb'
  action :create
  backup false
  notifies :restart, resources(:service => 'chef-indexer'), :delayed
end

template '/etc/chef/server.rb' do
  owner 'root'
  group 'root'
  mode 0600
  source 'server.rb.erb'
  action :create
  backup false
  # notifies :fixme, resource(:remote_file => 'fixme'), :delayed
end

%w(openid cache search_index openid/cstore openid/store).each do |dir|
  directory "/var/lib/chef/#{dir}" do
    owner 'root'
    group 'root'
    mode 0770
  end
end

directory '/etc/chef/certificates' do
  owner 'root'
  group 'root'
  mode 0700
end

apache_vhost node[:chef][:server_fqdn] do
  listen_on [{:address => '*', :port => '443', :ssl => true}, {:address => '*', :port => '444', :ssl => true}]
  # ssl_cert "/etc/chef/certificates/#{node[:chef][:server_fqdn]}.crt"
  # ssl_key "/etc/chef/certificates/#{node[:chef][:server_fqdn]}.key"
  docroot "#{node[:chef][:server_path]}/public"
  aliases Hash[
    '/facebox'       => "#{node[:chef][:server_slice_path]}/public/facebox",
    '/images'        => "#{node[:chef][:server_slice_path]}/public/images",
    '/javascripts'   => "#{node[:chef][:server_slice_path]}/public/javascripts",
    '/stylesheets'   => "#{node[:chef][:server_slice_path]}/public/stylesheets",
    '/web-app-theme' => "#{node[:chef][:server_slice_path]}/public/web-app-theme",
  ]
  # passenger_default_user 'chef'
  manage_docroot false
  directories Hash[
    "#{node[:chef][:server_path]}/public" => { :options => %w(-Indexes -FollowSymLinks) },
    "#{node[:chef][:server_slice_path]}/public" => { :options => %w(-Indexes -FollowSymLinks) },
  ]
end

chef_couch = '/var/lib/couchdb/chef.couch'

http_request 'compact chef couchdb' do
  action :post
  url 'http://localhost:5984/chef/_compact'
  only_if { File.file?(chef_couch) && File.size(chef_couch) > 100_000_000 }
end
