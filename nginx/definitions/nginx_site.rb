define :nginx_site, :action => :enable, :default => false,
  :template => "nginx_site.conf.erb", :cookbook => "nginx", :variables => {},
  :server_alias => nil, :docroot => nil, :manage_docroot => true,
  :owner => "root", :group => "root", :mode => "755",
  :ssl => true, :ssl_pem => nil, :ssl_key => nil,
  :passenger => false, :php => nil do

  set_iptables = false

  if params[:template] == "nginx_site.conf.erb"
    unless node[:nginx][:ports].include?("80")
      node[:nginx][:ports] << "80"
      set_iptables = true if node.recipe?("iptables")
    end
    unless node[:nginx][:ports].include?("443")
      node[:nginx][:ports] << "443"
      set_iptables = true if node.recipe?("iptables")
    end
  end

  if set_iptables
    iptables_rule "nginx" do
      variables(:ports => [node[:nginx][:ports]].flatten)
      cookbook "nginx"
    end
  end

  params[:docroot] ||= "/var/www/#{params[:name]}/htdocs"

  if params[:ssl]
    params[:ssl_pem] ||= "/etc/ssl/private/#{node[:fqdn]}.pem"
    params[:ssl_key] ||= "/etc/ssl/private/#{node[:fqdn]}.key"
  end

  config_path = if %w(yes true on 1).include?(params[:default].to_s)
    "/etc/nginx/vhosts.d/00_#{params[:name]}.conf"
  else
    "/etc/nginx/vhosts.d/#{params[:name]}.conf"
  end

  include_recipe "nginx"

  if params[:action] == :enable

    params[:php] ||= node[:nginx][:fcgi_php]

    unless [:manage_docroot, :docroot].any? { |a| %w(no false off 0).include?(params[a]) }
      directory params[:docroot] do
        owner params[:owner]
        group params[:group]
        mode params[:mode]
        recursive true
      end
    end

    template config_path do
      source params[:template]
      cookbook params[:cookbook]
      owner "root"
      group "nginx"
      mode "0640"
      variables({:params => params}.merge(params[:variables]))
      notifies :reload, resources(:service => "nginx")
    end

  elsif params[:action] == :disable

    file config_path do
      action :delete
      notifies :reload, resources(:service => "nginx")
    end

  end
end
