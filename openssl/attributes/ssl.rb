set_unless[:ssl][:self_signed_host_cert] = true
set_unless[:ssl][:self_signed_request_subject] = "/CN=#{node[:fqdn]}"
set_unless[:ssl][:remote_host_cert_name] = node[:fqdn]
