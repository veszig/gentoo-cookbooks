include_recipe 'portage'

package_keyword 'dev-db/couchdb'

package 'dev-db/couchdb'

service 'couchdb' do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end