set_unless[:monit][:mailservers] = ["smtp.#{node[:domain]}"]
set_unless[:monit][:alert_mail_from] = "monit@#{node[:fqdn]}"
set_unless[:monit][:alert_mail_to] = "root@#{node[:domain]}"
