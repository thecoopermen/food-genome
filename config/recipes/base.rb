def template(from, to)
  tmp_to = "/tmp/config_#{rand(Time.now.to_i)}"
  erb    = File.read(File.expand_path("../templates/#{from}", __FILE__))

  put ERB.new(erb).result(binding), tmp_to
  run "#{sudo} mv #{tmp_to} #{to}"
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def ensure_packages_installed(*packages)
  packages.each do |package|
    if capture("dpkg -s #{package} || echo 'No package found'").include?("No package found")
      run "#{sudo} DEBIAN_FRONTEND=noninteractive apt-get -qy install #{package}"
    end
  end
end

def bigger_version(a, b)
  # if the versions differ in any respect return the one with the larger more significant component
  (0...a.length).each do |i|
    return a if a[i] > b[i]
    return b if b[i] > a[i]
  end

  # if they don't differ it doesn't really matter which one is returned
  a
end

def with_user(other_user, &block)
  original_user = user
  set :user, other_user
  close_sessions
  yield
  set :user, original_user
  close_sessions
end

def close_sessions
  sessions.values.each { |session| session.close }
  sessions.clear
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -qy update"
    run "#{sudo} mkdir -p /data"
    run "#{sudo} chown deploy:sudo /data"
  end

  task :preinstall do
    unless capture("hostname") == application
      run "#{sudo} hostname $CAPISTRANO:HOST$"
      run "echo $CAPISTRANO:HOST$ > /tmp/hostname"
      run "#{sudo} mv /tmp/hostname /etc/"
    end

    unless capture("which add-apt-repository || echo 'No command'").include?("add-apt-repository")
      run "#{sudo} apt-get -qy update"
      run "#{sudo} apt-get -qy install python-software-properties"
    end
  end

  task :create_shared_config do
    run "mkdir -p #{shared_path}/config"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/* #{release_path}/config/"
  end
end

desc "Start an SSH session to the server (first in the list)"
task :ssh do
  exec "ssh deploy@#{find_servers_for_task(current_task).first}"
end

before 'deploy:install',     'deploy:preinstall'
after  'deploy',             'deploy:cleanup'
after  'deploy:update_code', 'deploy:symlink_shared'
after  'deploy:setup',       'deploy:create_shared_config'

