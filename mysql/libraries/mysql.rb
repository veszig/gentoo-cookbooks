module Opscode
  module MySQL

    @@dbh = nil
    @@users = nil
    @@grants = nil
    @@databases = nil

    def mysql_user_exists?(user)
      mysql_users.include?("#{user.name}@#{user.host}")
    end

    def mysql_force_password(user, password)
      password_ok = false
      select_query =
        "SELECT `Password`, PASSWORD('#{mysql_dbh.quote(password)}') " +
          "FROM `mysql`.`user` WHERE " +
          "`User` = '#{mysql_dbh.quote(user.name)}' AND " +
          "`Host` = '#{mysql_dbh.quote(user.host)}'"
      Chef::Log.debug("MySQL query: #{select_query}")
      mysql_dbh.query(select_query).each { |row| password_ok = row[0] == row[1] }
      unless password_ok
        Chef::Log.info("Reseting MySQL password of #{user.name}@#{user.host}.")
        set_query = "SET PASSWORD FOR #{mysql_user_handle(user)} " +
          "= PASSWORD('#{mysql_dbh.quote(password)}')"
        Chef::Log.debug("MySQL query: #{set_query}")
        mysql_dbh.query(set_query)
        mysql_dbh.reload
      else
        Chef::Log.debug("MySQL password OK for #{user.name}@#{user.host}.")
      end
    end

    def mysql_create_user(user, password)
      @@users = nil
      Chef::Log.info("Creating MySQL user #{user.name}@#{user.host}.")
      create_query = "CREATE USER #{mysql_user_handle(user)} " +
        "IDENTIFIED BY '#{mysql_dbh.quote(password)}'"
      Chef::Log.debug("MySQL query: #{create_query}")
      mysql_dbh.query(create_query)
      mysql_dbh.reload
    end

    def mysql_drop_user(user)
      @@users = nil
      Chef::Log.info("Dropping MySQL user #{user.name}@#{user.host}.")
      handle = mysql_user_handle(user)
      Chef::Log.debug("MySQL query: REVOKE ALL PRIVILEGES, GRANT OPTION FROM #{handle}")
      mysql_dbh.query("REVOKE ALL PRIVILEGES, GRANT OPTION FROM #{handle}")
      Chef::Log.debug("MySQL query: DROP USER #{handle}")
      mysql_dbh.query("DROP USER #{handle}")
      mysql_dbh.reload
    end

    def mysql_user_privileges(grant)
      handle = mysql_user_handle(grant, :grant)
      return @@grants[handle] if @@grants && @@grants[handle]
      @@grants ||= {}
      @@grants[handle] = {}
      Chef::Log.debug("MySQL query: SHOW GRANTS FOR #{handle}")
      # TODO don't ignore grant option
      mysql_dbh.query("SHOW GRANTS FOR #{handle}").each { |row|
        if row[0] =~ /\AGRANT (.*) ON [`'"]?(\S+?)[`'"]?(\.\S+)? TO .+\Z/
          @@grants[handle][$2] = $1.split(/,\s*/).map { |p|
            p == "ALL PRIVILEGES" ? "ALL" : p
          }
        end
      }
      @@grants[handle]
    end

    def mysql_manage_privileges(action, grant, privileges)
      handle = mysql_user_handle(grant, :grant)
      @@grants[handle] = nil
      db_escaped = grant.database == "*" ? "*" : "`#{mysql_dbh.quote(grant.database)}`"
      privilege_query = if action == :delete
        privileges += ["GRANT OPTION"] if grant.grant_option
        Chef::Log.info("Revoking #{privileges.join(", ")} privileges on MySQL database \"#{grant.database}\" from #{grant.user}@#{grant.user_host}.")
        "REVOKE #{privileges.join(", ")} ON #{db_escaped}.* FROM #{handle}"
      else
        if grant.grant_option
          Chef::Log.info("Granting #{privileges.join(", ")} privileges on MySQL database \"#{grant.database}\" to #{grant.user}@#{grant.user_host} WITH GRANT OPTION.")
          "GRANT #{privileges.join(", ")} ON #{db_escaped}.* TO #{handle} WITH GRANT OPTION"
        else
          Chef::Log.info("Granting #{privileges.join(", ")} privileges on MySQL database \"#{grant.database}\" to #{grant.user}@#{grant.user_host}.")
          "GRANT #{privileges.join(", ")} ON #{db_escaped}.* TO #{handle}"
        end
      end
      Chef::Log.debug("MySQL query: #{privilege_query}")
      mysql_dbh.query(privilege_query)
      mysql_dbh.reload
    end

    def mysql_manage_grants(action, grant)
      privileges = mysql_user_privileges(grant)
      current_db_privileges = privileges[grant.database] || []
      new_db_privileges = [grant.privileges].flatten.map { |p| p.upcase }
      case action
      when :create
        unless current_db_privileges.include?("ALL")
          missing_privileges = new_db_privileges - current_db_privileges
          unless missing_privileges.empty?
            mysql_manage_privileges(:create, grant, missing_privileges)
          else
            Chef::Log.debug("MySQL user #{grant.user}@#{grant.user_host} has all necessary privileges on database \"#{grant.database}\".")
          end
        else
          Chef::Log.debug("MySQL user #{grant.user}@#{grant.user_host} has ALL privileges on database \"#{grant.database}\".")
        end
      when :delete
        if new_db_privileges.include?("ALL") && !current_db_privileges.empty?
          mysql_manage_privileges(:delete, grant, "ALL")
        else
          unwanted_privileges = current_db_privileges & new_db_privileges
          unless unwanted_privileges.empty?
            mysql_manage_privileges(:delete, grant, unwanted_privileges)
          else
            Chef::Log.debug("MySQL user #{grant.user}@#{grant.user_host} has no unwanted privileges on database \"#{grant.database}\".")
          end
        end
      end
    end

    def mysql_database_exists?(database)
      mysql_databases.include?(database)
    end

    def mysql_create_database(database)
      @@databases = nil
      Chef::Log.info("Creating MySQL database \"#{database}\".")
      Chef::Log.debug("MySQL query: CREATE DATABASE #{mysql_dbh.quote(database)}")
      mysql_dbh.query("CREATE DATABASE #{mysql_dbh.quote(database)}")
    end

    def mysql_drop_database(database)
      @@databases = nil
      Chef::Log.info("Dropping MySQL database \"#{database}\".")
      Chef::Log.debug("MySQL query: DROP DATABASE #{mysql_dbh.quote(database)}")
      mysql_dbh.query("DROP DATABASE #{mysql_dbh.quote(database)}")
    end

    private

    def mysql_dbh
      return @@dbh if @@dbh
      require "mysql"
      host = "localhost"
      password = nil
      oksection = false
      File.read("/root/.my.cnf").split("\n").each { |line|
        if line.strip =~ /\A\[(\S+)\]\Z/
          oksection = %w(mysql client).include?($1)
        elsif oksection && line.strip =~ /\Ahost\s*=\s*(\S+)\Z/
          host = $1
        elsif oksection && line.strip =~ /\Apassword\s*=\s*(\S+)\Z/
          password = $1
        end
      }
      @@dbh = ::Mysql.real_connect(host, "root", password)
    end

    def mysql_users
      return @@users if @@users
      @@users = []
      select_query = "SELECT CONCAT(`User`, '@', `Host`) FROM `mysql`.`user`"
      Chef::Log.debug("MySQL query: #{select_query}")
      mysql_dbh.query(select_query).each { |row| @@users << row[0] }
      @@users
    end

    def mysql_user_handle(user, resource_type = :user)
      if resource_type == :grant
        # user is a grant :)
        "`#{mysql_dbh.quote(user.user)}`@`#{mysql_dbh.quote(user.user_host)}`"
      else
        "`#{mysql_dbh.quote(user.name)}`@`#{mysql_dbh.quote(user.host)}`"
      end
    end

    def mysql_databases
      return @@databases if @@databases
      @@databases = mysql_dbh.list_dbs
    end
  end
end
