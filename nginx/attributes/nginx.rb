set_unless[:nginx][:worker_processes] = node[:cpu][:total]
set_unless[:nginx][:worker_connections] = "1024"
set_unless[:nginx][:keepalive_timeout] = "75 20"
set_unless[:nginx][:ports] = []
set_unless[:nginx][:fcgi_php] = false
set_unless[:nginx][:passenger] = false
