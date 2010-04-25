maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Sets up gentoo specific config files and directories"
version          "0.2"
recipe           "gentoo", "Basic gentoo configuration"
recipe           "gentoo::portage", "Portage specific configuration files"
recipe           "gentoo::hardened", "Hardened Gentoo modifications"
supports         "gentoo"
depends          "eix"

attribute "gentoo/profile",
  :display_name => "Gentoo Profile (/etc/make.profile)",
  :description  => "Relative path of the gentoo profile",
  :type         => "string",
  :default      => "default/linux/$arch/10.0"

attribute "gentoo/use_flags",
  :display_name => "make.conf USE",
  :description  => "Global USE flags",
  :type         => "array",
  :default      => [
    "-*", "acl", "berkdb", "bzip2", "cracklib", "crypt", "cxx", "fam", "fortran",
    "gdbm", "glibc-omitfp", "gnutls", "iconv", "idn", "mmx", "modules",
    "mudflap", "multilib", "ncurses", "nls", "nptl", "nptlonly", "openmp", "pam",
    "pcre", "posix", "readline", "sse", "sse2", "ssl", "sysfs", "sysvipc",
    "threads", "threadsafe", "unicode", "urandom", "xml", "zlib"
  ]

attribute "gentoo/cflags",
  :display_name => "make.conf CFLAGS",
  :description  => "C compiler flags",
  :type         => "string",
  :default      => "-march=native -O2 -pipe"

attribute "gentoo/makeopts",
  :display_name => "make.conf MAKEOPTS",
  :description  => "Options for parallel make",
  :type         => "string",
  :default      => "-j$cpunr+1"

attribute "gentoo/portage_features",
  :display_name => "make.conf FEATURES",
  :description  => "Actions portage takes by default",
  :type         => "array",
  :default      => %w(sandbox sfperms strict buildpkg parallel-fetch)

attribute "gentoo/emerge_options",
  :display_name => "make.conf EMERGE_DEFAULT_OPTS",
  :description  => "Default options passed to emerge",
  :type         => "array",
  :default      => ["--verbose"]

attribute "gentoo/overlay_directories",
  :display_name => "make.conf PORTDIR_OVERLAY",
  :description  => "Directories in which external ebuilds are stored",
  :type         => "array",
  :default      => []

attribute "gentoo/collision_ignores",
  :display_name => "make.conf COLLISION_IGNORE",
  :description  => "Files and directories for which collision-protect is disabled",
  :type         => "array",
  :default      => []

attribute "gentoo/accept_licenses",
  :display_name => "make.conf ACCEPT_LICENSE",
  :description  => "Mask packages based on licensing restrictions",
  :type         => "array",
  :default      => []

attribute "gentoo/use_expands",
  :display_name => "USE_EXPANDs",
  :description  => "Arrays of USE_EXPANDS (e.g. NGINX_MODULES)",
  :type         => "hash",
  :default      => {}

attribute "gentoo/elog_mailuri",
  :display_name => "make.conf ELOG_MAILURI",
  :description  => "Recipient and SMTP server for elog emails",
  :type         => "string",
  :default      => ""

attribute "gentoo/elog_mailfrom",
  :display_name => "make.conf ELOG_MAILFROM",
  :description  => "Sender email for elog emails",
  :type         => "string",
  :default      => "portage@$fqdn"

attribute "gentoo/rsync_mirror",
  :display_name => "make.conf SYNC",
  :description  => "Rsync mirror used for emerge --sync",
  :type         => "string",
  :default      => "rsync://rsync.gentoo.org/gentoo-portage"

attribute "gentoo/distfile_mirrors",
  :display_name => "make.conf GENTOO_MIRRORS",
  :description  => "Distfile mirrors",
  :type         => "array",
  :default      => ["http://gentoo.osuosl.org/"]

attribute "gentoo/portage_binhost",
  :display_name => "make.conf PORTAGE_BINHOST",
  :description  => "Host from which portage will grab prebuilt-binary packages",
  :type         => "string",
  :default      => ""

attribute "gentoo/hwtimezone",
  :display_name => "Hardware Timezone",
  :description  => "Timezone of the hardware clock (UTC or local)",
  :type         => "string",
  :default      => "UTC"

attribute "gentoo/timezone",
  :display_name => "Timezone",
  :description  => "Timezone",
  :type         => "string",
  :default      => "UTC"

attribute "gentoo/synchwclock",
  :display_name => "conf.d/clock CLOCK_SYSTOHC",
  :description  => "Set the hardware clock to the system time during shutdown",
  :default      => "true"
  # FIXME :type => [ "trueclass", "falseclass" ]

attribute "gentoo/locales",
  :display_name => "locale.gen",
  :description  => "Locales to generate",
  :type         => "array",
  :default      => ["en_US ISO-8859-1", "en_US.UTF-8 UTF-8"]

attribute "gentoo/sysctl",
  :display_name => "sysctl.conf",
  :description  => "sysctl keys and values",
  :type         => "hash",
  :default      => {
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
