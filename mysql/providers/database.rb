include Opscode::MySQL

action :create do
  unless mysql_database_exists?(new_resource.name)
    mysql_create_database(new_resource.name)
  else
    Chef::Log.debug("MySQL database \"#{new_resource.name}\" exists.")
  end
  unless new_resource.owner.to_s == ""
    mysql_user "#{new_resource.owner}" do
      host new_resource.owner_host
    end
    mysql_grant "#{new_resource.name}_#{new_resource.owner}" do
      database new_resource.name
      user new_resource.owner
      user_host new_resource.owner_host
      privileges "ALL"
    end
  end
end

action :delete do
  if mysql_database_exists?(new_resource.name)
    mysql_drop_database(new_resource.name)
  else
    Chef::Log.debug("MySQL database \"#{new_resource.name}\" doesn't exist.")
  end
  unless new_resource.owner.to_s == ""
    mysql_grant "#{new_resource.name}_#{new_resource.owner}" do
      action :delete
      database new_resource.name
      user new_resource.owner
      user_host new_resource.owner_host
    end
  end
end
