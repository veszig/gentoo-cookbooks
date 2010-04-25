include_recipe "gentoo::portage"

missing_global_use_flags = %w(hardened pie pic) - node[:gentoo][:use_flags]

unless missing_global_use_flags.empty?
  node[:gentoo][:use_flags] += missing_global_use_flags
end

unless node[:gentoo][:profile] =~ /hardened/
  Chef::Log.error("\"node[:gentoo][:profile]\" isn't a hardened profile!")
end

hardened_sysctl = {
  "kernel.grsecurity.audit_chdir" => 0,
  "kernel.grsecurity.audit_ipc" => 0,
  "kernel.grsecurity.audit_mount" => 1,
  "kernel.grsecurity.chroot_caps" => 0,
  "kernel.grsecurity.chroot_deny_chmod" => 0,
  "kernel.grsecurity.chroot_deny_chroot" => 1,
  "kernel.grsecurity.chroot_deny_fchdir" => 0,
  "kernel.grsecurity.chroot_deny_mknod" => 1,
  "kernel.grsecurity.chroot_deny_mount" => 1,
  "kernel.grsecurity.chroot_deny_pivot" => 1,
  "kernel.grsecurity.chroot_deny_shmat" => 0,
  "kernel.grsecurity.chroot_deny_sysctl" => 1,
  "kernel.grsecurity.chroot_deny_unix" => 0,
  "kernel.grsecurity.chroot_enforce_chdir" => 1,
  "kernel.grsecurity.chroot_execlog" => 0,
  "kernel.grsecurity.chroot_findtask" => 1,
  "kernel.grsecurity.chroot_restrict_nice" => 0,
  "kernel.grsecurity.dmesg" => 1,
  "kernel.grsecurity.execve_limiting" => 1,
  "kernel.grsecurity.exec_logging" => 0,
  "kernel.grsecurity.fifo_restrictions" => 1,
  "kernel.grsecurity.forkfail_logging" => 1,
  "kernel.grsecurity.linking_restrictions" => 1,
  "kernel.grsecurity.signal_logging" => 1,
  "kernel.grsecurity.timechange_logging" => 1,
  "kernel.grsecurity.tpe" => 0,
  "kernel.grsecurity.tpe_gid" => 0,
  "kernel.grsecurity.tpe_restrict_all" => 0
}

missing_sysctl_keys = hardened_sysctl.keys - node[:gentoo][:sysctl].keys

unless missing_sysctl_keys.empty?
  missing_sysctl_keys.each { |sysctl_key|
    # only set sysctl key if the attribute is present on the system
    if File.exists?("/proc/sys/#{sysctl_key.gsub(".", "/")}")
      node[:gentoo][:sysctl][sysctl_key] = hardened_sysctl[sysctl_key]
    else
      Chef::Log.debug("#{sysctl_key} sysctl key not set.")
    end
  }
end
