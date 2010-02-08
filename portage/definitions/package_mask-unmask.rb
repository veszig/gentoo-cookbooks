# abstraction of package_mask and package_unmask
define :package_mask_unmask, :what => nil, :action => nil do

  include_recipe 'portage'

  # =dev-lang/php-5.2.8-r2 => dev-lang-php-5-2-8-r2
  mask_file = params[:name].gsub(/[\/\.]/, '-').gsub(/[^a-z0-9_\-]/i, '')

  if params[:action] == :delete
    file "/etc/portage/package.#{params[:what].to_s}/#{mask_file}" do
      action :delete
    end
  else
    template "/etc/portage/package.#{params[:what].to_s}/#{mask_file}" do
      owner 'root'
      group 'portage'
      mode 0660
      backup false
      source 'package.mask-unmask.erb'
      cookbook 'gentoo'
      variables(:package => params[:name])
    end
  end

end

# package_mask '=dev-lang/php-5.2.8-r2'
#
# package_mask '>=dev-lang/php-5.0' do
#   action :delete
# end
define :package_mask, :action => nil do
  package_mask_unmask params[:name] do
    what :mask
    action params[:action]
  end
end

# package_unmask '=dev-db/mysql-community-5.1.21_beta'
#
# package_unmask '=dev-db/mysql-5.0.83' do
#   action :delete
# end
define :package_unmask, :action => nil do
  package_mask_unmask params[:name] do
    what :unmask
    action params[:action]
  end
end
