default[:php][:cgi] = false
default[:php][:use_flags] = %w(bcmath berkdb bzip2 calendar cli crypt ctype
  curl exif expat ftp gd gdbm hash inifile mcal memlimit mhash pdo reflection
  session simplexml sockets spl suhosin sysvipc tokenizer truetype unicode wddx
  xml xmlrpc xsl zip zlib)
default[:php][:open_basedir] = ""
default[:php][:memory_limit] = "128M"
default[:php][:max_execution_time] = "30"
default[:php][:post_max_size] = "20M"
default[:php][:upload_max_filesize] = "20M"
default[:php][:allow_url_fopen] = false
