default[:apache][:listen_ports] = [80]
default[:apache][:modules] = [ 'PROXY' ]

default[:apache][:default_virtualhost_name] = fqdn

default[:apache][:ssl] = false
default[:apache][:ssl_cert_file] = '/etc/ssl/apache2/server.crt'
default[:apache][:ssl_key_file] = '/etc/ssl/apache2/server.key'

# default[:apache][:ssl_cert] = if File.readable?(node[:apache][:ssl_cert_file])
#   File.read(node[:apache][:ssl_cert_file])
# elsif !node[:ssl_cert].nil? && !node[:ssl_cert].empty?
#   node[:ssl_cert]
# else
#   ''
# end
# 
# default[:apache][:ssl_key] = if File.readable?(node[:apache][:ssl_key_file])
#   File.read(node[:apache][:ssl_key_file])
# elsif !node[:ssl_key].nil? && !node[:ssl_key].empty?
#   node[:ssl_key]
# else
#   ''
# end
