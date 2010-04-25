include Opscode::Gentoo::Portage

action :create do
  manage_package_foo(:create, "unmask", new_resource.name)
end

action :delete do
  manage_package_foo(:delete, "unmask", new_resource.name)
end
