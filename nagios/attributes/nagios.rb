default[:nagios][:nrpe][:use] = %w(nagios-dns nagios-ping nagios-ssh snmp -suid)
default[:nagios][:nrpe][:monitoring_ips] = ["127.0.0.1"]
