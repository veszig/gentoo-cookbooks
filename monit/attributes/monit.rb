default[:monit][:mailservers] = ["smtp.#{node[:domain]}"]
default[:monit][:alert_mail_from] = "monit@#{node[:fqdn]}"
default[:monit][:alert_mail_to] = "root@#{node[:domain]}"
