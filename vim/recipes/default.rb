include_recipe "gentoo::portage"

unless node[:gentoo][:use_flags].include?("vim-syntax")
  node[:gentoo][:use_flags] << "vim-syntax"
  generate_make_conf "added vim-syntax USE flag"
end

gentoo_package "app-editors/vim" do
  action :upgrade
  use "vim-pager"
end
