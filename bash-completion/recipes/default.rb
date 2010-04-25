include_recipe "gentoo::portage"

unless node[:gentoo][:use_flags].include?("bash-completion")
  node[:gentoo][:use_flags] << "bash-completion"
  generate_make_conf "added bash-completion USE flag"
end

gentoo_package "app-shells/bash-completion" do
  action :upgrade
end
