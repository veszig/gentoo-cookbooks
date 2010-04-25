maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Sets up and configures net-snmp server"
version          "0.1"
supports         "gentoo"
depends          "gentoo"

attribute "snmpd/monitoring_ips",
  :display_name => "Monitoring IP addresses",
  :description  => "IP addresses allowed to access the snmp server",
  :type         => "array",
  :default      => ["127.0.0.1"]

attribute "snmpd/community",
  :display_name => "Community",
  :description  => "SNMP Community name",
  :type         => "string",
  :default      => "public"

attribute "snmpd/syslocation",
  :display_name => "System location",
  :description  => "System location",
  :type         => "string",
  :default      => "here"

attribute "snmpd/syscontact",
  :display_name => "System contact",
  :description  => "System contact",
  :type         => "string",
  :default      => "root <root@$domain>"

attribute "snmpd/disks",
  :display_name => "Disks",
  :description  => "Disks to monitor",
  :type         => "array",
  :default      => ["/mounted", "/partitions"]

attribute "snmpd/execs",
  :display_name => "Execs",
  :description  => "External exec calls",
  :type         => "array",
  :default      => []
