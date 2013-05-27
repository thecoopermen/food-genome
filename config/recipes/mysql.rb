require 'securerandom'

namespace :mysql do
  namespace :server do
    desc "Install latest stable release of mysql server"
    task :install, roles: :db do
      ensure_packages_installed "mysql-server"
    end
    after "deploy:install", "mysql:server:install"

    desc "Create a database.yml file and the associated database"
    task :database, roles: :db do
      target_path = File.join(shared_path, 'config', 'database.yml')

      unless 'true' ==  capture("if [ -e #{target_path} ]; then echo 'true'; fi").strip
        password = SecureRandom.hex.encode('UTF-8')
        username = application.gsub(/[-.]/, '_')
        database = "#{username}_#{rails_env}"
        contents = {
          "#{rails_env}" => {
            'database' => database,
            'adapter'  => 'mysql2',
            'username' => username,
            'password' => password,
            'pool'     => 5,
            'timeout'  => 5000
          }
        }

        put contents.to_yaml, target_path
        run "chmod 400 #{target_path}"
        run "mysql -u root" do |channel, stream, data|
          if data =~ /mysql\> /
            channel.send_data "create database #{database};\n"
            channel.send_data "create user '#{username}'@'localhost';\n"
            channel.send_data "set password for '#{username}'@'localhost' = PASSWORD('#{password}');\n"
            channel.send_data "set password for 'root'@'localhost' = PASSWORD('#{password}');\n"
            channel.send_data "grant all on #{database}.* to '#{username}'@'localhost';\n"
            channel.send_data "exit\n"
          end
        end
      end
    end
    before "deploy:symlink_shared", "mysql:server:database"
  end

  namespace :client do
    desc "Install latest stable release of mysql client, along with development libraries for the 'mysql' gem"
    task :install, roles: :app do
      ensure_packages_installed "libmysqlclient-dev", "libmysqlclient18"
    end
    after "deploy:install", "mysql:client:install"
  end
end

