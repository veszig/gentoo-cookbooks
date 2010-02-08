include_recipe 'portage'

package_keyword '=www-apache/passenger-2.2.5'

package 'www-apache/passenger'

unless node[:apache][:modules].include?('PASSENGER')
  node[:apache][:modules] << 'PASSENGER'

  execute 'set APACHE2_OPTS' do
    action :run
  end
end

# execute 'PassengerDefaultUser' do
#   command '/bin/sed -i "s/^PassengerDefaultUser apache/\#PassengerDefaultUser apache/" /etc/apache2/modules.d/30_mod_passenger.conf'
#   only_if '/bin/grep "^PassengerDefaultUser apache" /etc/apache2/modules.d/30_mod_passenger.conf'
# end
