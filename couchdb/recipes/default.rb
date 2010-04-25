package "dev-db/couchdb" do
  action :upgrade
end

service "couchdb" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, resources(:package => "dev-db/couchdb")
end

if node.recipe?("monit")
  monit_check "couchdb"
end

if node.recipe?("nagios::nrpe")
  nrpe_command "couchdb"
end
