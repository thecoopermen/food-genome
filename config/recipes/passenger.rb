require 'net/ftp'

namespace :passenger do

  def latest_pcre_version
    @latest_pcre_version ||= begin
      version = [ 0, 0 ]
      Net::FTP.open('ftp.csx.cam.ac.uk') do |ftp|
        ftp.login
        ftp.chdir('/pub/software/programming/pcre/')
        ftp.nlst('pcre*.tar.gz').each do |file|
          matches = file.match(/pcre-(\d+)\.(\d+)\.tar\.gz/).to_a.map(&:to_i).slice(1, 2)
          version = bigger_version(version, matches)
        end
      end
      version.join('.')
    end
  end

  def root_dir
    @root_dir ||= capture("passenger-config --root").strip
  end

  desc "Install the passenger gem and prepare it for nginx"
  task :install do
    # prerequisites
    ensure_packages_installed("libcurl4-openssl-dev")

    # get the passenger gem install
    verb = capture("gem list").include?("passenger") ? "update" : "install"
    run "gem #{verb} passenger"
    run "rbenv rehash"

    # build the nginx Passenger module (unless it's already built)
    unless capture("(cd #{root_dir} && ls agents/nginx/) || echo 'passenger not compiled'").include?("PassengerHelperAgent")
      run "cd #{root_dir} && rake -s nginx:clean nginx RELEASE=yes"
    end

    # add the Passenger module to the nginx configuration command
    set :nginx_config_args, nginx_config_args + [ "--add-module=#{root_dir}/ext/nginx" ]
  end
  after "nginx:download", "passenger:install"

  desc "Setup the passenger configuration options"
  task :setup do
    # set up the passenger configuration for nginx
    ruby_path = capture("rbenv which ruby").strip

    set :nginx_http_config, nginx_http_config + [
      "passenger_root #{root_dir};",
      "passenger_ruby #{ruby_path};"
    ].join("\n")

    set :nginx_server_config, nginx_server_config + "passenger_enabled on;"
  end
  before "nginx:setup", "passenger:setup"

  task :download_pcre do
    unless capture("ls /opt/nginx/src/ || echo ''").include?(latest_pcre_version)
      prefix = 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre'
      run "curl -sL #{prefix}/pcre-#{latest_pcre_version}.tar.gz -o /tmp/pcre.tar.gz"
      run "#{sudo} mkdir -p /opt/nginx/src"
      run "#{sudo} chown -R deploy:sudo /opt/nginx"
      run "tar xzf /tmp/pcre.tar.gz -C /opt/nginx/src/"
    end

    set :nginx_config_args, nginx_config_args + [ "--with-pcre=/opt/nginx/src/pcre-#{latest_pcre_version}" ]
  end
  after "passenger:install", "passenger:download_pcre"
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

