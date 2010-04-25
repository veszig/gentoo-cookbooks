package "sys-process/vixie-cron" do
  action :upgrade
end

service "vixie-cron" do
  supports :status => true, :restart => true
  action [:enable, :start]
  subscribes :restart, resources(:package => "sys-process/vixie-cron")
end

if node.recipe?("monit")
  monit_check "vixie-cron"
end

if node.recipe?("nagios::nrpe")
  cron "touch /tmp/cron_lastrun" do
    minute "*/5"
    user "nagios"
    command "/bin/touch /tmp/cron_lastrun"
  end
  nrpe_command "vixie-cron"
end
