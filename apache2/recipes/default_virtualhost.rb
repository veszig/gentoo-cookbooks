include_recipe 'apache2'

apache_vhost node[:apache][:default_virtualhost_name] do
  
end

