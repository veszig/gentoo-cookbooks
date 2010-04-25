maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Installs and configures Monit"
version          "0.1"
supports         "gentoo"

attribute "monit/mailservers",
  :display_name => "Mailservers",
  :description  => "List of mailservers for alert delivery",
  :type         => "array",
  :default      => ["smtp.$domain"]

attribute "monit/alert_mail_from",
  :display_name => "Alert mail From",
  :description  => "Sender of monit alert emails",
  :type         => "string",
  :default      => "monit@$fqdn"

attribute "monit/alert_mail_to",
  :display_name => "Alert mail To",
  :description  => "Recipient of monit alert emails",
  :type         => "string",
  :default      => "root@$domain"
