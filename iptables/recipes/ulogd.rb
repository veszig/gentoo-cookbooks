gentoo_package_use "app-admin/ulogd -mysql -pcap -postgres -sqlite"

# TODO remove when =sys-kernel/linux-headers-2.6.32 hits stable
# http://bugs.gentoo.org/show_bug.cgi?id=297068
gentoo_package "sys-kernel/linux-headers" do
  action :upgrade
  keywords "=sys-kernel/linux-headers-2.6.32"
end

package "app-admin/ulogd" do
  action :upgrade
end

service "ulogd" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  subscribes :restart, resources(:package => "app-admin/ulogd")
end

if node.recipe?("logrotate")
  logrotate_config "ulogd"
end
