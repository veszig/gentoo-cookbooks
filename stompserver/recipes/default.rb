include_recipe 'portage'

package_keyword 'dev-ruby/stompserver'

package 'dev-ruby/stompserver'

service 'stompserver' do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
