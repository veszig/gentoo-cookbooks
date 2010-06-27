default[:mysql][:root_password] = ""
default[:mysql][:server_address] = "localhost"
default[:mysql][:client_ips] = %w(127.0.0.1)
default[:mysql][:encoding] = "utf8"
default[:mysql][:server][:mode] = "standalone" # || "master" || "slave"

# http://dev.mysql.com/doc/refman/5.0/en/replication-options.html#option_mysqld_server-id
default[:mysql][:server][:id] = node[:ipaddress].gsub(".", "").to_i % 4294967295 # hopefully unique

# http://dev.mysql.com/doc/refman/5.0/en/server-options.html#option_mysqld_bind-address
default[:mysql][:server][:bind_address] = "127.0.0.1"

# http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#sysvar_max_connections
default[:mysql][:server][:max_connections] = 100

# misc variables
default[:mysql][:server][:mysqld_variables] = {
  "join_buffer_size" => "4M",
  "key_buffer" => "192M",
  "max_allowed_packet" => "32M",
  "max_heap_table_size" => "32M",
  "myisam_sort_buffer_size" => "64M",
  "query_cache_limit" => "2M",
  "query_cache_size" => "48M",
  "read_buffer_size" => "4M",
  "read_rnd_buffer_size" => "4M",
  "sort_buffer_size" => "4M",
  "table_cache" => "512",
  "thread_cache_size" => "8",
  "thread_concurrency" => "8",
  "tmp_table_size" => "128M",
  "net_buffer_length" => "64K"
}
