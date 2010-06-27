default[:ssl][:self_signed_host_cert] = true
default[:ssl][:self_signed_request_subject] = "/CN=#{node[:fqdn]}"
default[:ssl][:remote_host_cert_name] = node[:fqdn]
