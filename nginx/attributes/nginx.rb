default[:nginx][:worker_processes] = node[:cpu][:total]
default[:nginx][:worker_connections] = "1024"
default[:nginx][:keepalive_timeout] = "75 20"
default[:nginx][:ports] = []
default[:nginx][:fcgi_php] = false
default[:nginx][:passenger] = false
