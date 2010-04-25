set_unless[:php][:cgi] = false
set_unless[:php][:use_flags] = %w(bcmath berkdb bzip2 calendar cli crypt ctype
  curl exif expat ftp gd gdbm hash inifile mcal memlimit mhash pdo reflection
  session simplexml sockets spl suhosin sysvipc tokenizer truetype unicode wddx
  xml xmlrpc xsl zip zlib)
set_unless[:php][:open_basedir] = ""
set_unless[:php][:memory_limit] = "128M"
set_unless[:php][:max_execution_time] = "30"
set_unless[:php][:post_max_size] = "20M"
set_unless[:php][:upload_max_filesize] = "20M"
set_unless[:php][:allow_url_fopen] = false
