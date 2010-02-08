define :apache_vhost, :template => 'apache_vhost.conf.erb', :cookbook => 'apache2', :listen_on => [{:address => '*', :port => 80, :ssl => false}, {:address => '*', :port => 443, :ssl => true}], :manage_docroot => true, :owner => 'root', :group => 'www-data' do

  include_recipe 'apache2'

  params[:docroot] ||= "/var/www/#{params[:name]}/htdocs"

  if params[:action] == :delete

    file "/etc/apache2/vhosts.d/#{params[:name]}.conf" do
      action :delete
      notifies :restart, resources(:service => 'apache2'), :delayed
    end

    if params[:manage_docroot]
      directory params[:docroot] do
        action :delete
      end
    end

  else

    if node[:apache][:ssl]
      params[:ssl_cert_file] ||= node[:apache][:ssl_cert_file]
      params[:ssl_key_file]  ||= node[:apache][:ssl_key_file]
    end

    params[:directories] ||= { params[:docroot] => {} }
    params[:directories].each { |dir,dirparams|
      params[:directories][dir] = {
        :options => %w(Indexes FollowSymLinks),
        :allow_override => 'None',
      }.merge(dirparams)
    }

    if params[:manage_docroot]
      directory params[:docroot] do
        owner params[:owner]
        group params[:group]
        mode 0755
      end
    end

    template "/etc/apache2/vhosts.d/#{params[:name]}.conf" do
      owner 'root'
      group 'root'
      mode 0600
      backup false
      source params[:template]
      cookbook params[:cookbook]
      notifies :restart, resources(:service => 'apache2'), :delayed
      variables(:params => params)
    end
  end
end