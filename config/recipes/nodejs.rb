namespace :nodejs do
  task :add_apt_repo, :roles => :app do
    unless capture('ls /etc/apt/sources.list.d').include?('chris-lea')
      run "#{sudo} add-apt-repository -y ppa:chris-lea/node.js"
    end
  end
  before "deploy:install", "nodejs:add_apt_repo"

  desc "Install the latest relase of Node.js"
  task :install, roles: :app do
    ensure_packages_installed("nodejs")
  end
  after "deploy:install", "nodejs:install"
end

