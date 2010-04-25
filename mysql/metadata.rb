maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Installs and configures MySQL"
version          "0.1"
recipe           "mysql::client", "Installs and configures MySQL client"
recipe           "mysql::server", "Installs and configures MySQL server"
supports         "gentoo"
depends          "gentoo"
depends          "password"

attribute "mysql/root_password",
  :display_name => "MySQL root password",
  :description  => "MySQL root password (leave empty if you want to generate and store it locally)",
  :type         => "string",
  :default      => ""

attribute "mysql/server_address",
  :display_name => "MySQL server address",
  :description  => "Address of the MySQL server where the client will connect to by default",
  :type         => "string",
  :default      => "127.0.0.1"

attribute "mysql/encoding",
  :display_name => "MySQL encoding",
  :description  => "Default encoding used in MySQL server and client",
  :type         => "string",
  :default      => "utf8"
