package "net-misc/openssh" do
  action :upgrade
end

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :port => node[:sshd][:port],
    :permit_root_login => node[:sshd][:permit_root_login],
    :password_auth => node[:sshd][:password_auth],
    :allow_users => [node[:sshd][:allow_users]].flatten
  )
end

service "sshd" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  subscribes :reload, resources(:template => "/etc/ssh/sshd_config")
  subscribes :restart, resources(:package => "net-misc/openssh")
end

if node.recipe?("iptables")
  iptables_rule "sshd" do
    variables(:sshd_port => node[:sshd][:port])
  end
end

if node.recipe?("monit")
  monit_check "sshd" do
    variables(:sshd_port => node[:sshd][:port])
  end
end

if node.recipe?("nagios::nrpe")
  nrpe_command "sshd" do
    variables(:sshd_port => node[:sshd][:port])
  end
end
