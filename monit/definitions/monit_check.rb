define :monit_check, :enable => true, :source => nil, :cookbook => nil, :variables => {} do
  template_source =  params[:source] || "#{params[:name]}.monit.erb"
  template "/etc/monit.d/#{params[:name]}" do
    source template_source
    cookbook params[:cookbook] if params[:cookbook]
    owner "root"
    group "root"
    mode "0600"
    variables params[:variables]
    notifies :reload, resources(:service => "monit")
    action params[:enable] ? :create : :delete
  end
end
