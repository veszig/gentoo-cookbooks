action :create do
  template_source = new_resource.source || "#{new_resource.name}.iptables.erb"
  template "/etc/iptables.d/#{new_resource.name}" do
    source template_source
    cookbook new_resource.cookbook unless new_resource.cookbook.nil?
    owner "root"
    group "root"
    mode "0700"
    variables new_resource.variables
    notifies :run, resources(:execute => "rebuild-iptables")
  end
end

action :delete do
  file "/etc/iptables.d/#{new_resource.name}" do
    action :delete
  end
end
