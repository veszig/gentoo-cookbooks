include Opscode::Gentoo::Portage

action :create do
  manage_package_foo(:create, "mask", new_resource.name)
end

action :delete do
  manage_package_foo(:delete, "mask", new_resource.name)
end
