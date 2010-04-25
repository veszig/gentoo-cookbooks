maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Installs and configures PHP"
version          "0.1"
supports         "gentoo"
depends          "gentoo"

attribute "php/cgi",
  :display_name => "PHP CGI support",
  :description  => "Enable CGI support in PHP",
  :default      => "false"
  # FIXME :type => [ "trueclass", "falseclass" ]

attribute "php/use_flags",
  :display_name => "PHP USE flags",
  :description  => "PHP USE flags",
  :type         => "array",
  :default      => %w(bcmath berkdb bzip2 calendar cli crypt ctype curl exif
                      expat ftp gd gdbm hash inifile mcal memlimit mhash pdo
                      reflection session simplexml sockets spl suhosin sysvipc
                      tokenizer truetype unicode wddx xml xmlrpc xsl zip zlib)

attribute "php/open_basedir",
  :display_name => "php.ini open_basedir",
  :description  => "php.ini open_basedir",
  :type         => "string",
  :default      => ""

attribute "php/memory_limit",
  :display_name => "php.ini memory_limit",
  :description  => "php.ini memory_limit",
  :type         => "string",
  :default      => "128M"

attribute "php/max_execution_time",
  :display_name => "php.ini max_execution_time",
  :description  => "php.ini max_execution_time",
  :type         => "string",
  :default      => "30"

attribute "php/post_max_size",
  :display_name => "php.ini post_max_size",
  :description  => "php.ini post_max_size",
  :type         => "string",
  :default      => "20M"

attribute "php/upload_max_filesize",
  :display_name => "php.ini upload_max_filesize",
  :description  => "php.ini upload_max_filesize",
  :type         => "string",
  :default      => "20M"

attribute "php/allow_url_fopen",
  :display_name => "php.ini allow_url_fopen",
  :description  => "php.ini allow_url_fopen",
  :default      => "false"
  # FIXME :type => [ "trueclass", "falseclass" ]
