# package_keyword '=net-analyzer/nagios-core-3.1.2' do
#   keyword '~amd64'
# end
#
# package_keyword 'net-analyzer/netdiscover'
#
# package_keyword '=net-analyzer/nagios-core-3.1.2' do
#   action :delete
# end
define :package_keyword, :action => nil, :keyword => nil do

  include_recipe 'portage'

  # =net-analyzer/nagios-core-3.1.2 => net-analyzer-nagios-core-3-1-2
  # =net-analyzer/netdiscover => net-analyzer-netdiscover
  keyword_file = params[:name].gsub(/[\/\.]/, '-').gsub(/[^a-z0-9_\-]/i, '')

  if params[:action] == :delete
    file "/etc/portage/package.keywords/#{keyword_file}" do
      action :delete
    end
  else
    template "/etc/portage/package.keywords/#{keyword_file}" do
      owner 'root'
      group 'portage'
      mode 0660
      backup false
      source 'package.keyword.erb'
      cookbook 'portage'
      variables(:package => params[:name], :keyword => params[:keyword])
    end
  end

end
