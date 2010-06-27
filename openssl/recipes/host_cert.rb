include_recipe "openssl"

# Add users who are allowed to read the host cert to this group.
group "ssl" do
  append true
end

directory "/etc/ssl/private" do
  owner "root"
  group "ssl"
  mode "0710"
end

if %w(no false off 0).include?(node[:ssl][:self_signed_host_cert].to_s)

  %w(crt key pem).each { |ext|
    cookbook_file "/etc/ssl/private/#{node[:fqdn]}.#{ext}" do
      source "#{node[:ssl][:remote_host_cert_name]}.#{ext}"
      owner "root"
      group "ssl"
      mode "0640"
    end
  }

else

  bash "create_self_signed_ssl_cert" do
    user "root"
    cwd "/etc/ssl/private"
    code <<-EOC
    umask 077
    openssl genrsa 2048 > #{node[:fqdn]}.key
    openssl req -subj "#{node[:ssl][:self_signed_request_subject]}" -new -x509 -nodes -sha1 -days 3650 -key #{node[:fqdn]}.key > #{node[:fqdn]}.crt
    cat #{node[:fqdn]}.key #{node[:fqdn]}.crt > #{node[:fqdn]}.pem
    EOC
    not_if { File.size?("/etc/ssl/private/#{node[:fqdn]}.pem") }
  end

  %w(crt key pem).each { |ext|
    file "/etc/ssl/private/#{node[:fqdn]}.#{ext}" do
      owner "root"
      group "ssl"
      mode "0640"
    end
  }

end
