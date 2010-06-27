# "inspired by" http://blog.bitfluent.com/post/196658820/using-chef-server-indexes-as-a-simple-dns

# TODO deal with machines that have multiple public IP addresses
localips = [node[:ipaddress]]

hosts = {}

search(:node, "*:*") do |n|
  unless n[:ipaddress].nil?
    # TODO ignore RFC 1918 IP addresses on different LANs
    hosts[n[:ipaddress]] = [n[:hostname], n[:fqdn], n[:dns_aliases]]
  end
end

# knife data bag create hosts
# knife data bag create hosts foo
#   {
#     "id": "foo",
#     "ip": "1.2.3.4",
#     "hosts": ["foo", "foo.bar.tld"]
#   }
begin
  data_bag("hosts").each { |id|
    item = data_bag_item("hosts", id)
    hosts[item["ip"]] ||= []
    hosts[item["ip"]] += item["hosts"]
  }
rescue Net::HTTPServerException => e
  # never mind if we don't have a "hosts" data_bag
  raise e unless e.response.code == "404"
end

localhosts = [
  node[:fqdn], node[:hostname], "localhost", node[:dns_aliases]
].flatten.compact.uniq

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :localips => localips,
    :localhosts => localhosts,
    :hosts => hosts
  )
end
