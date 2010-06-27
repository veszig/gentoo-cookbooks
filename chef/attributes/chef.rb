default[:chef][:syslog] = false
default[:chef][:client][:server_url] = "http://chef.#{node[:domain]}:4000"
default[:chef][:server][:amqp_pass] = "testing"
default[:chef][:server][:server_proxy_port] = "4443"
default[:chef][:server][:webui_proxy_port] = "4483"
