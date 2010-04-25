include Opscode::Gentoo::Portage

action :create do
  manage_package_foo(:create, "use", new_resource.name)
end

action :delete do
  manage_package_foo(:delete, "use", new_resource.name)
end
