maintainer       "Gábor Vészi"
maintainer_email "veszig@done.hu"
license          "Apache 2.0"
description      "Installs git"
version          "0.1"
supports         "gentoo"

attribute "git/client/subversion",
  :display_name => "git-svn",
  :description  => "Subversion support for git",
  :default      => "false"
  # FIXME :type => [ "trueclass", "falseclass" ]

attribute "git/client/cvs",
  :display_name => "git-cvsimport",
  :description  => "CVS support for git",
  :default      => "false"
  # FIXME :type => [ "trueclass", "falseclass" ]
