include Opscode::Gentoo::Portage

action :create do
  manage_package_foo(:create, "keywords", new_resource.name)
end

action :delete do
  manage_package_foo(:delete, "keywords", new_resource.name)
end
