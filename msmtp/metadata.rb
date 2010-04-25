maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Installs and configures msmtp"
version          "0.1"
supports         "gentoo"

attribute "msmtp/host",
  :display_name => "SMTP host",
  :description  => "Outgoing SMTP host",
  :type         => "string",
  :default      => "smtp.$domain"

attribute "msmtp/from",
  :display_name => "SMTP from",
  :description  => "Default enverlope-from address",
  :type         => "string",
  :default      => "blachole@$fqdn"

attribute "msmtp/user",
  :display_name => "SMTP user",
  :description  => "SMTP user for authentication",
  :type         => "string",
  :default      => ""

attribute "msmtp/password",
  :display_name => "SMTP password",
  :description  => "SMTP password for authentication",
  :type         => "string",
  :default      => ""
