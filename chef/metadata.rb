maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Installs and configures Chef Client and Server"
version          "0.1"
recipe           "chef::client", "Chef Client configuration"
recipe           "chef::overlay", "Installs the Chef gentoo overlay"
recipe           "chef::server", "Chef Server configuration"
recipe           "chef::server_proxy", "Nginx SSL proxy for Chef Server"
recipe           "chef::webui", "Chef WebUI configuration"
recipe           "chef::webui_proxy", "Nginx SSL proxy for Chef WebUI"
supports         "gentoo"

%w(couchdb gentoo git nginx rabbitmq).each { |cb|
  depends cb
}

attribute "chef/syslog",
  :display_name => "Log to syslog",
  :description  => "Log to syslog",
  :default      => "false"
  # FIXME :type => [ "trueclass", "falseclass" ]

attribute "chef/client/server_url",
  :display_name => "Chef Server URL",
  :description  => "Public URL of the Chef server",
  :type         => "string",
  :default      => "http://chef.$domain:4000"

attribute "chef/server/amqp_pass",
  :display_name => "AMQP password",
  :description  => "The password set in RabbitMQ",
  :type         => "string",
  :default      => "testing"

attribute "chef/server/server_proxy_port",
  :display_name => "Chef Server Proxy port",
  :description  => "Nginx SSL proxy for the Chef Server listens on this port",
  :type         => "string",
  :default      => "4443"

attribute "chef/server/webui_proxy_port",
  :display_name => "Chef Server Proxy port",
  :description  => "Nginx SSL proxy for the Chef WebUI listens on this port",
  :type         => "string",
  :default      => "4483"
