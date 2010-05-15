include_recipe "gentoo::portage"
include_recipe "git::client"

# TODO find out why the git resource syncs on every run
chef_overlay_reference = "2beec328eba362f8a6ecd1b747fca747af0f4aa0"
ref_file = "/usr/local/chef-overlay/.git/refs/heads/master"
current_ref = File.size?(ref_file) ? File.read(ref_file).strip : ""

unless chef_overlay_reference == current_ref
  git "/usr/local/chef-overlay" do
    repository "git://github.com/veszig/chef-overlay.git"
    reference chef_overlay_reference
    user "root"
    group "portage"
    action :sync
    notifies :run, resources(:execute => "eix-update")
  end
end

unless node[:gentoo][:overlay_directories].include?("/usr/local/chef-overlay")
  node[:gentoo][:overlay_directories] << "/usr/local/chef-overlay"
  generate_make_conf "added chef-overlay to PORTDIR_OVERLAY"
end
