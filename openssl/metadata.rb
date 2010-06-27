maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Installs OpenSSL"
version          "0.1"
recipe           "openssl", "Installs OpenSSL"
recipe           "openssl::host_cert", "Generates a self signed certificate for the host"
supports         "gentoo"
depends          "gentoo"

attribute "ssl/self_signed_host_cert",
  :display_name => "Self-signed host certificate",
  :description  => "Generate a self-signed cert? (or get one via cookbook_file)",
  :default      => "true"
  # FIXME :type => [ "trueclass", "falseclass" ]

attribute "ssl/self_signed_request_subject",
  :display_name => "Request Subject",
  :description  => "The subject of the requested certificate",
  :type         => "string",
  :default      => "/CN=$fqdn"

attribute "ssl/remote_host_cert_name",
  :display_name => "Host certificate name",
  :description  => "Name of the host certificate cookbook_files",
  :type         => "string",
  :default      => "$fqdn"
