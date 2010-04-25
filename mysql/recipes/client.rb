include_recipe "password"
include_recipe "gentoo::portage"

unless node[:gentoo][:use_flags].include?("mysql")
  node[:gentoo][:use_flags] << "mysql"
  generate_make_conf "added mysql USE flag"
end

unless node.recipe?("mysql::server")
  gentoo_package "dev-db/mysql" do
    action :upgrade
    use "minimal"
  end
end

# mysql_gem_package = package "dev-ruby/mysql-ruby" do
#   action :nothing
# end
# mysql_gem_package.run_action(:upgrade)
# Gem.clear_paths

gentoo_package "dev-ruby/mysql-ruby" do
  action :upgrade
end

# set node[:mysql][:root_password] to "" and we'll generate and store the
# mysql root password locally
mysql_root_password = if node[:mysql][:root_password] == ""
  # node[:mysql][:root_password] = Opscode::Password.get("mysql/root")
  get_password("mysql/root")
else
  node[:mysql][:root_password]
end

template "/root/.my.cnf" do
  source "dotmy.cnf.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :host => node[:mysql][:server_address],
    :password => mysql_root_password,
    :encoding => node[:mysql][:encoding]
  )
end
