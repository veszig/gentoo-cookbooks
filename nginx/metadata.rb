maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Installs and configures Nginx"
version          "0.1"
supports         "gentoo"
depends          "openssl"
depends          "php"

attribute "nginx/worker_processes",
  :display_name => "Worker Processes",
  :description  => "max_clients = worker_processes * worker_connections",
  :type         => "string",
  :default      => "$cpu_total"

attribute "nginx/worker_connections",
  :display_name => "Worker Connections",
  :description  => "max_clients = worker_processes * worker_connections",
  :type         => "string",
  :default      => "8192"

attribute "nginx/keepalive_timeout",
  :display_name => "Keepalive Timeout",
  :description  => "Timeout for keep-alive connections with the client",
  :type         => "string",
  :default      => "75 20"

attribute "nginx/ports",
  :display_name => "Nginx ports",
  :description  => "List of ports nginx should listen on",
  :type         => "array",
  :default      => []

attribute "nginx/fastcgi",
  :display_name => "Nginx FastCGI support",
  :description  => "Enable FastCGI support in Nginx",
  :default      => "false"
  # FIXME :type => [ "trueclass", "falseclass" ]

attribute "nginx/passenger",
  :display_name => "Nginx Passenger support",
  :description  => "Enable Passenger support in Nginx",
  :default      => "false"
  # FIXME :type => [ "trueclass", "falseclass" ]
