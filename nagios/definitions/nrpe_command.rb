define :nrpe_command, :enable => true, :source => nil, :variables => {} do
  template_source =  params[:source] || "#{params[:name]}.nrpe.erb"
  template "/etc/nagios/nrpe.d/#{params[:name]}.cfg" do
    source template_source
    owner "root"
    group "nagios"
    mode "0640"
    variables params[:variables]
    notifies :reload, resources(:service => "nrpe")
    action params[:enable] ? :create : :delete
  end
end
