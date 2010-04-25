include Opscode::MySQL

action :create do
  mysql_manage_grants(:create, new_resource)
end

action :delete do
  mysql_manage_grants(:delete, new_resource)
end
