include Opscode::Gentoo::Portage

action :install do
  conditional_emerge(new_resource, :install)
end

action :upgrade do
  conditional_emerge(new_resource, :upgrade)
end

action :reinstall do
  conditional_emerge(new_resource, :reinstall)
end

action :remove do
  unmerge(new_resource)
end

action :purge do
  unmerge(new_resource)
end
