gentoo_package "mail-mta/ssmtp" do
  action :remove
end

gentoo_package "mail-mta/msmtp" do
  action :upgrade
end

template "/etc/msmtprc" do
  source "msmtprc.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :smtp_host => node[:msmtp][:host],
    :domain => node[:fqdn],
    :smtp_from => node[:msmtp][:from],
    :smtp_user => node[:msmtp][:user],
    :smtp_password => node[:msmtp][:password]
  )
end
