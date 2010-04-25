if %w(yes true on 1).include?(node[:php][:cgi].to_s)
  %w(cgi force-cgi-redirect).each { |flag|
    node[:php][:use_flags] << flag unless node[:php][:use_flags].include?(flag)
  }
end

gentoo_package "dev-lang/php" do
  use node[:php][:use_flags]
end

(node[:php][:use_flags] & %w(apache2 cgi cli)).each { |d|
  template "/etc/php/#{d}-php5/php.ini" do
    source "php.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
      :open_basedir => node[:php][:open_basedir],
      :max_execution_time => node[:php][:max_execution_time],
      :memory_limit => node[:php][:memory_limit],
      :post_max_size => node[:php][:post_max_size],
      :upload_max_filesize => node[:php][:upload_max_filesize],
      :allow_url_fopen => node[:php][:allow_url_fopen]
    )
  end
}
