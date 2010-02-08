default[:chef][:server_version] = '0.7.10'
default[:chef][:server_fqdn] = fqdn
default[:chef][:server_ssl_req]  = "/C=HU/ST=Budapest/L=Budapest/O=#{domain}/OU=IT/CN=#{chef[:server_fqdn]}/emailAddress=root@#{domain}"
default[:chef][:server_path] = "/usr/lib/ruby/gems/1.8/gems/chef-server-#{chef[:server_version]}"
default[:chef][:server_slice_path] = "/usr/lib/ruby/gems/1.8/gems/chef-server-slice-#{chef[:server_version]}"

# chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
# default[:chef][:server_token] = (1..42).inject('') { |s,i| s << chars[rand(chars.size-1)] }
# default[:chef][:openid_providers] = %w(https://chef.example.org myopenid.com)
# default[:chef][:openid_identifiers] = %w(someone.example.org https://example.myopenid.com/)
