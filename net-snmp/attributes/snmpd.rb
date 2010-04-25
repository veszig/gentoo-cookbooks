set_unless[:snmpd][:monitoring_ips] = ["127.0.0.1"]
set_unless[:snmpd][:community] = "public"
set_unless[:snmpd][:syslocation] = "here"
set_unless[:snmpd][:syscontact] = "root <root@#{node[:domain]}>"
set_unless[:snmpd][:disks] = node[:filesystem].keys.select { |k| k =~ /\A\/dev\// }.map { |d| node[:filesystem][d][:mount] }
set_unless[:snmpd][:execs] = []
# set_unless[:snmpd][:execs] = [
#   {
#     :name => "postfix_queue_size",
#     :command => "/usr/local/bin/postfix_queue_size"
#   },
#   {
#     :name => "sda_smart_errors",
#     :command => "/usr/local/bin/smart_errors /dev/sda"
#   }
# ]
