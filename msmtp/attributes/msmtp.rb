set_unless[:msmtp][:host] = "smtp.#{node[:domain]}"
set_unless[:msmtp][:from] = "blackhole@#{node[:fqdn]}"
set_unless[:msmtp][:user] = ""
set_unless[:msmtp][:password] = ""
