include_recipe 'portage'

apache_use = ['-threads']

if node[:apache][:ssl]
  apache_use <<  'ssl'
  node[:apache][:modules] << 'SSL'
  node[:apache][:listen_ports] << 443 unless node[:apache][:listen_ports].include?(443)
else
  apache_use << '-ssl'
end

package_use 'www-servers/apache' do
  flags apache_use
end

package 'www-servers/apache'

%w(00_default_vhost.conf 00_default_ssl_vhost.conf default_vhost.include).each do |f|
  file "/etc/apache2/vhosts.d/#{f}" do
    action :delete
    backup false
  end
end

execute 'ServerSignature Off' do
  command '/bin/sed -i "s/^ServerSignature On$/ServerSignature Off/" /etc/apache2/modules.d/00_default_settings.conf'
  not_if '/bin/grep "^ServerSignature Off$" /etc/apache2/modules.d/00_default_settings.conf'
end

template '/etc/apache2/modules.d/00_custom_settings.conf' do
  owner 'root'
  group 'root'
  mode 0644
  source '00_custom_settings.conf.erb'
end

# TODO
# if node[:apache][:ssl]
#   if node[:apache][:ssl_cert].empty? || node[:apache][:ssl_key].empty?
#     execute 'create new apache SSL key and cert' do
#       ...
#     end
#   else
#     execute 'create apache SSL key and cert' do
#       ...
#     end
#   end
# end

a2o = node[:apache][:modules].sort.map { |o| '-D ' + o }.join(' ')
execute 'set APACHE2_OPTS' do
  command "/bin/sed -i 's/^APACHE2_OPTS=\".*\"$/APACHE2_OPTS=\"#{a2o}\"/' /etc/conf.d/apache2"
  not_if "/bin/grep '^APACHE2_OPTS=\"#{a2o}\"' /etc/conf.d/apache2"
end

service 'apache2' do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end