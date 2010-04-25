class Chef::Recipe
  include Opscode::Password
end

unless node[:password][:directory].to_s == ""
  directory node[:password][:directory] do
    owner "root"
    group "root"
    mode "0700"
    recursive true
  end
end
