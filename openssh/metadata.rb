maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Sets up and configures an openssh server"
version          "0.1"
recipe           "gentoo", "Basic opensshd configuration"
recipe           "gentoo::known_hosts", "Sets up global known_hosts file"
supports         "gentoo"

attribute "sshd/port",
  :display_name => "sshd_config Port",
  :description  => "Port sshd listens on",
  :type         => "string",
  :default      => "22"

attribute "sshd/permit_root_login",
  :display_name => "sshd_config PermitRootLogin",
  :description  => "Permit root login",
  :default      => "false"
  # FIXME :type => [ "trueclass", "falseclass" ]

attribute "sshd/password_auth",
  :display_name => "sshd_config PasswordAuthentication",
  :description  => "Permit password based authentication",
  :default      => "true"
  # FIXME :type => [ "trueclass", "falseclass" ]

attribute "sshd/allow_users",
  :display_name => "sshd_conf AllowUsers",
  :description  => "List of users permitted to login (if empty, everyone is allowed)",
  :type         => "array",
  :default      => []
