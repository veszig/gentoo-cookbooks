include_recipe "openssh"

known_keys = {}

search(:node, "*:*") do |n|
  # TODO ignore RFC 1918 IP addresses on different LANs
  known_keys[n[:keys][:ssh][:host_rsa_public]] ||= []
  known_keys[n[:keys][:ssh][:host_rsa_public]] += [n[:ipaddress], n[:hostname], n[:fqdn], n[:dns_alias]]
end

# knife data bag create ssh_known_hosts
# knife data bag create ssh_known_hosts foo
#   {
#     "id": "foo",
#     "key": "AAAAB3NzaC1yc2EAAAABIwAAAQEA4vPrvrrEKSRR4lPFEwLFBHnD6jZos+hALpBveHSovNlIRj0vt1LJTZwSe3OB9iyELR2UP9ibYi/L+NK+rqacKD28OF7oF+OA6ubp7DxsFsaBC+RXP1guQy411VGq1ug+t91ihxYeUYAQC6nXGfFkQbjZ97+ADOeED4YtgfJ5WeBv+WycbexPpflanxuUVWxmgfGtnKMeAp3gZAk8M//Hsl1x/0eEC7DmkIn7lk8vPVO7dZy0JLPy1Rcu4Ei0qBqXsRQUXzIyeHcz4NVCV4pwhHPR3J0Jb0/6eJpBl2e7WcHYFZSwOTY6nqptCl708pNwojnKhuKQGiWrcN8Qy7CUoQ==",
#     "hosts": ["1.2.3.4", "foo", "foo.bar.tld"]
#   }
begin
  data_bag("ssh_known_hosts").each { |id|
    item = data_bag_item("hosts", id)
    known_keys[item["key"]] ||= []
    known_keys[item["key"]] += item["hosts"]
  }
rescue Net::HTTPServerException => e
  # never mind if we don't have a "ssh_known_hosts" data_bag
  raise e unless e.response.code == "404"
end

template "/etc/ssh/ssh_known_hosts" do
  source "known_hosts.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:known_keys => known_keys)
end
