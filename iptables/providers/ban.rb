action :create do
  banfile = "ban-#{new_resource.name.gsub(/[^0-9a-b\._\-]/i, "_")}"
  template "/etc/iptables.d/#{banfile}" do
    source "ban.erb"
    cookbook "iptables"
    owner "root"
    group "root"
    mode "0700"
    variables(
      :subject => new_resource.name,
      :port => new_resource.port,
      :proto => new_resource.proto
    )
    notifies :run, resources(:execute => "rebuild-iptables")
  end
end

action :delete do
  banfile = "ban-#{new_resource.name.gsub(/[^0-9a-b\._\-]/i, "_")}"
  file "/etc/iptables.d/#{banfile}" do
    action :delete
  end
end
