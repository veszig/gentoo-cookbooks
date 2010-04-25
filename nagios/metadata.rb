maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Installs and configures Nagios"
version          "0.1"
recipe           "nagios::nrpe", "Installs and configures Nagios NRPE"
supports         "gentoo"

attribute "nagios/nrpe/use",
  :display_name => "Nagios NRPE USE flags",
  :description  => "Set USE flags for net-analyzer/nagios-nrpe",
  :type         => "array",
  :default      => %w(nagios-dns nagios-ntp nagios-ping nagios-ssh snmp -suid)

attribute "nagios/nrpe/commands",
  :display_name => "Nagios NRPE commands",
  :description  => "Commands that Nagios NRPE exposes",
  :type         => "hash",
  :default      => {
    "check_disk_root" => "/usr/lib/nagios/plugins/check_disk -w 15% -c 10% -p /",
    "check_load" => "/usr/lib/nagios/plugins/check_load -w 20,15,10 -c 25,20,15",
    "check_time" => "/usr/lib/nagios/plugins/check_ntp_time -H pool.ntp.org -w 30 -c 60",
    "check_procs_running" => "/usr/lib/nagios/plugins/check_procs -w 20 -c 40 -s R",
    "check_procs_total" => "/usr/lib/nagios/plugins/check_procs -w 600 -c 700",
    "check_procs_zombie" => "/usr/lib/nagios/plugins/check_procs -w 5 -c 10 -s Z"
  }

attribute "nagios/nrpe/monitoring_ips",
  :display_name => "Nagios NRPE monitoring IPs",
  :description  => "IP addresses allowed to connect to Nagios NRPE",
  :type         => "array",
  :default      => ["127.0.0.1"]
