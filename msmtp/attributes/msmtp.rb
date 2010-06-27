default[:msmtp][:host] = "smtp.#{node[:domain]}"
default[:msmtp][:from] = "blackhole@#{node[:fqdn]}"
default[:msmtp][:user] = ""
default[:msmtp][:password] = ""
