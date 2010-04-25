define :generate_make_conf do
  Chef::Log.debug("Generating /etc/make.conf: #{params[:name]}")
  template "/etc/make.conf" do
    source "make.conf.erb"
    cookbook "gentoo"
    owner "root"
    group "root"
    mode "0644"
    action :create
    variables(
      :use_flags => node[:gentoo][:use_flags],
      :chost => "#{node[:kernel][:machine]}-pc-linux-gnu",
      :cflags => node[:gentoo][:cflags],
      :makeopts => [node[:gentoo][:makeopts]].flatten,
      :features => [node[:gentoo][:portage_features]].flatten,
      :emerge_options => [node[:gentoo][:emerge_options]].flatten,
      :overlays => [node[:gentoo][:overlay_directories]].flatten,
      :collision_ignores => [node[:gentoo][:collision_ignores]].flatten,
      :licenses => [node[:gentoo][:accept_licenses]].flatten,
      :ruby_targets => [node[:gentoo][:ruby_targets]].flatten,
      :use_expands => node[:gentoo][:use_expands],
      :elog_mailuri => node[:gentoo][:elog_mailuri],
      :elog_mailfrom => node[:gentoo][:elog_mailfrom],
      :rsync_mirror => node[:gentoo][:rsync_mirror],
      :distfile_mirrors => [node[:gentoo][:distfile_mirrors]].flatten,
      :portage_binhost => node[:gentoo][:portage_binhost]
    )
  end
end
