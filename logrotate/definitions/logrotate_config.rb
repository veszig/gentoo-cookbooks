define :logrotate_config, :enable => true, :source => nil do
  remote_source =  params[:source] || "#{params[:name]}.logrotate"
  remote_file "/etc/logrotate.d/#{params[:name]}" do
    source remote_source
    owner "root"
    group "root"
    mode "0600"
    action params[:enable] ? :create : :delete
  end
end
