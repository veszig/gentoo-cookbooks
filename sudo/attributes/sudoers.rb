set_unless[:sudo][:groups] = ["wheel"]
set_unless[:sudo][:users] = []
set_unless[:sudo][:commands] = []
# set_unless[:sudo][:commands] = [
#   { :user => "backup", :nopasswd => true,
#     :path => "/usr/bin/rsync,/usr/bin/mysqldump" },
#   { :group => "dev", :nopasswd => false,
#     :path => "/etc/init.d/nginx,/etc/init.d/mysql" },
#   { :group => "dev", :nopasswd => false,
#     :path => "sudoedit /etc/nginx/vhosts.d/foobar.tld.conf,/etc/mysql/my.cnf" }
# ]
