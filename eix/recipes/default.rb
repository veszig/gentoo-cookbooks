execute "eix-update" do
  command "/usr/bin/eix-update"
  action :nothing
end

package "app-portage/eix" do
  action :upgrade
  notifies :run, resources(:execute => "eix-update")
end
