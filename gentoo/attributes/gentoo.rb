set_unless[:gentoo][:profile] = case node[:kernel][:machine]
  when "x86_64"
    "default/linux/amd64/10.0"
  else
    "default/linux/#{node[:kernel][:machine]}/10.0"
  end

set_unless[:gentoo][:use_flags] = [
  "-*", "berkdb", "bzip2", "cracklib", "crypt", "cxx", "fam", "gdbm",
  "glibc-omitfp", "gnutls", "iconv", "idn", "mmx", "modules", "mudflap",
  "multilib", "ncurses", "nls", "nptl", "nptlonly", "openmp", "pam",
  "pcre", "posix", "readline", "ruby", "sse", "sse2", "ssl", "sysfs",
  "sysvipc", "threads", "threadsafe", "unicode", "urandom", "xml", "zlib"
]

set_unless[:gentoo][:cflags] = "-march=native -O2 -pipe"
set_unless[:gentoo][:makeopts] = "-j#{node[:cpu][:total].to_i+1}"

set_unless[:gentoo][:portage_features] = %w(sandbox sfperms strict buildpkg parallel-fetch)
set_unless[:gentoo][:emerge_options] = ["--verbose"] # + ["--jobs=3", "--load-average=3"]
set_unless[:gentoo][:overlay_directories] = []
set_unless[:gentoo][:collision_ignores] = []
set_unless[:gentoo][:accept_licenses] = []
set_unless[:gentoo][:ruby_targets] = ["ruby18"]
set_unless[:gentoo][:use_expands] = {}
set_unless[:gentoo][:elog_mailuri] = "" # "foo@example.com smtp.example.com"
set_unless[:gentoo][:elog_mailfrom] = "portage@#{node[:fqdn]}"
set_unless[:gentoo][:rsync_mirror] = "rsync://rsync.gentoo.org/gentoo-portage"
set_unless[:gentoo][:distfile_mirrors] = ["http://gentoo.osuosl.org/"]
set_unless[:gentoo][:portage_binhost] = ""

set_unless[:gentoo][:hwtimezone] = "UTC" # "local"
set_unless[:gentoo][:timezone] = "UTC" # "Europe/Budapest"
set_unless[:gentoo][:synchwclock] = true # false

set_unless[:gentoo][:locales] = ["en_US ISO-8859-1", "en_US.UTF-8 UTF-8"]

set_unless[:gentoo][:sysctl] = {
  "kernel.panic" => 60,
  "kernel.shmmax" => 83886080,
  "net.ipv4.conf.all.rp_filter" => 1,
  "net.ipv4.conf.default.accept_redirects" => 0,
  "net.ipv4.conf.default.accept_source_route" => 0,
  "net.ipv4.conf.default.log_martians" => 1,
  "net.ipv4.conf.default.rp_filter" => 1,
  "net.ipv4.icmp_echo_ignore_broadcasts" => 1,
  "net.ipv4.icmp_ignore_bogus_error_responses" => 1,
}
