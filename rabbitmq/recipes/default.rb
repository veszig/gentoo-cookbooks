include_recipe "gentoo::portage"
include_recipe "chef::overlay"

gentoo_package_keywords "=net-misc/rabbitmq-server-1.7.2-r2"

package "net-misc/rabbitmq-server" do
  action :upgrade
end

service "rabbitmq" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, resources(:package => "net-misc/rabbitmq-server")
end

# TODO monit needs a pidfile, rabbitmq doesn't create any http://bit.ly/cfZWXC
# if node.recipe?("monit")
#   monit_check "rabbitmq"
# end

if node.recipe?("nagios::nrpe")
  nrpe_command "rabbitmq"
end
