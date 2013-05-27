namespace :redis do
  desc "Install latest stable release of redis"
    task :install, roles: :redis do
      ensure_packages_installed "redis-server"
    end
  after "deploy:install", "redis:install"
end

