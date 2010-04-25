include_recipe "gentoo::portage"

git_use_flags = []
if %w(yes true on 1).include?(node[:git][:client][:subverson].to_s)
  git_use_flags << "subversion"
end
if %w(yes true on 1).include?(node[:git][:client][:cvs].to_s)
  git_use_flags << "cvs"
end

gentoo_package "dev-vcs/git" do
  use git_use_flags unless git_use_flags.empty?
end
