#
# Cookbook Name:: chef
# Recipe:: client
#
# Copyright 2009, Opscode, Inc.
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

include_recipe 'portage'

package_keyword '=app-admin/chef-0.7.10'
package_keyword '=dev-ruby/abstract-1.0.0'
package_keyword '=dev-ruby/erubis-2.6.5'
package_keyword '=dev-ruby/extlib-0.9.12'
package_keyword '=dev-ruby/json-1.1.9'
package_keyword '=dev-ruby/json_pure-1.1.9'
package_keyword '=dev-ruby/mixlib-cli-1.0.4'
package_keyword '=dev-ruby/mixlib-config-1.0.12'
package_keyword '=dev-ruby/mixlib-log-1.0.3'
package_keyword '=dev-ruby/ohai-0.3.2'
package_keyword '=dev-ruby/ruby-openid-2.1.7'
package_keyword '=dev-ruby/stomp-1.1'
package_keyword '=dev-ruby/systemu-1.2.0'

service "chef-client" do
  action :nothing
end

package 'app-admin/chef' do
  version node[:chef][:client_version]
  notifies :restart, resources(:service => 'chef-client'), :delayed
end

['/etc/chef', '/var/lib/chef', '/var/log/chef', '/var/run/chef'].each { |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode 0770
  end
}

template '/etc/chef/client.rb' do
  source 'client.rb.erb'
  owner 'root'
  group 'root'
  mode 0600
  backup false
  notifies :restart, resources(:service => 'chef-client'), :delayed
end

# execute "Register client node with Chef Server" do
#   command "/usr/bin/env chef-client -t \`cat /etc/chef/validation_token\` && rm /etc/chef/validation_token"
#   only_if { File.exists?("/etc/chef/validation_token") }
#   not_if  { File.exists?("#{node[:chef][:path]}/cache/registration") }
# end

service 'chef-client' do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
