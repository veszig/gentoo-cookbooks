package "app-admin/monit" do
  action :upgrade
end

directory "/etc/monit.d" do
  owner "root"
  group "root"
  mode "0700"
end

template "/etc/monitrc" do
  source "monitrc.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :mailservers => [node[:monit][:mailservers]].flatten,
    :from => node[:monit][:alert_mail_from],
    :to => node[:monit][:alert_mail_to]
  )
end

service "monit" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
  subscribes :reload, resources(:template => "/etc/monitrc")
  subscribes :restart, resources(:package => "app-admin/monit")
  ignore_failure true
end

if node.recipe?("nagios::nrpe")
  nrpe_command "monit"
end
