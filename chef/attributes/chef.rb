set_unless[:chef][:syslog] = false
set_unless[:chef][:client][:server_url] = "http://chef.#{node[:domain]}:4000"
set_unless[:chef][:server][:amqp_pass] = "testing"
set_unless[:chef][:server][:server_proxy_port] = "4443"
set_unless[:chef][:server][:webui_proxy_port] = "4483"
