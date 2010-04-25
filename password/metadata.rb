maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Helps to manage passwords"
version          "0.1"

attribute "password/directory",
  :display_name => "Password directory",
  :description  => "Store locally generated passwords in this directory (passwords are not persisted if empty)",
  :type         => "string",
  :default      => ""
