# package_use 'app-emulation/xen-tools' do
#   flags %w(-screen api hvm pygrub)
# end
# package_use 'net-analyzer/ntop' do
#   flags '-snmp'
# end
define :package_use, :flags => nil, :action => nil do

  include_recipe 'portage'

  package params[:name] do
    action :nothing
  end

  # app-emulation/xen-tools => app-emulation-xen-tools
  use_file = params[:name].gsub(/[\/\.]/, '-').gsub(/[^a-z0-9_\-]/i, '')

  if params[:action] == :delete
    file "/etc/portage/package.use/#{use_file}" do
      action :delete
    end
  else
    template "/etc/portage/package.use/#{use_file}" do
      owner 'root'
      group 'portage'
      mode 0660
      backup false
      notifies :install, resources(:package => params[:name]), :delayed
      source 'package.use.erb'
      cookbook 'portage'
      variables(
        :package => params[:name],
        :flags => params[:flags].respond_to?(:join) ? params[:flags] : params[:flags].to_s.split(/\s+/)
      )
    end
  end

end
