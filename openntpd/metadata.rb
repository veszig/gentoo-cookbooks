maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Sets up and configures openntpd server"
version          "0.1"
supports         "gentoo"

attribute "ntpd/listen_on",
  :display_name => "Listen on",
  :description  => "Addresses to listen on (e.g. *, 1.2.3.4, ::1)",
  :type         => "array",
  :default      => []

attribute "ntpd/pool",
  :display_name => "Pool",
  :description  => "NTP pool to sync to",
  :type         => "string",
  :default      => "pool.ntp.org"
