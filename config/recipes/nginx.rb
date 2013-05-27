require 'open-uri'

namespace :nginx do

  def latest_nginx_version
    @latest_nginx_version ||= begin
      version = [ 0, 0, 0 ]
      open("http://nginx.org/download/").read.scan(/<a href="nginx-(\d+)\.(\d+)\.(\d+)\.tar\.gz">/) do |matches|
        version = bigger_version(version, matches.map(&:to_i))
      end
      version.join('.')
    end
  end

  desc "Download the source for the latest stable nginx release"
  task :download, :roles => :web do
    unless capture("ls /opt/nginx/src/ || echo ''").include?(latest_nginx_version)
      run "curl -sL http://nginx.org/download/nginx-#{latest_nginx_version}.tar.gz -o /tmp/nginx.tar.gz"
      run "#{sudo} mkdir -p /opt/nginx/src"
      run "#{sudo} chown -R deploy:sudo /opt/nginx"
      run "tar xzf /tmp/nginx.tar.gz -C /opt/nginx/src/"
    end
  end
  before "deploy:install", "nginx:download"

  task :default_args, :roles => :web do
    set :nginx_config_args, [
      "--prefix=/opt/nginx",
      "--with-http_ssl_module",
      "--with-http_gzip_static_module",
      "--with-cc-opt=-Wno-error"
    ]
  end
  after "nginx:download", "nginx:default_args"

  desc "Compile latest stable release of nginx"
  task :compile, :roles => :web do
    # don't do this if we already have an nginx built with all the same options
    config = capture("/opt/nginx/sbin/nginx -V || echo 'nginx is not installed'")
    matches = config.match(/^configure arguments: (.*)$/)
    if matches
      current_options = matches[1].split(' ')
      next if current_options.all? { |option| nginx_config_args.include?(option) }
    end

    # configure and compile nginx
    run [
      "cd /opt/nginx/src/nginx-#{latest_nginx_version}",
      "./configure #{nginx_config_args.join(' ')}",
      "make install"
    ].join(" && ")
  end
  after "deploy:install", "nginx:compile"

  task :set_defaults, :roles => :web do
    set_default :nginx_http_config,   ''
    set_default :nginx_server_config, ''
  end
  before "deploy:setup", "nginx:set_defaults"

  desc "Setup nginx configuration for this application"
  task :setup, :roles => :web do
    template "nginx_passenger.erb", "/opt/nginx/conf/nginx.conf"
    template "nginx_upstart.conf",  "/etc/init/nginx.conf"

    run "#{sudo} chown root:root /etc/init/nginx.conf"
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop].each do |command|
    desc "#{command} nginx"
    task command, :roles => :web do
      run "#{sudo} #{command} nginx"
    end
  end

  desc "restart nginx"
  task :restart, :roles => :web do
    command = (capture("status nginx") =~ /\d+/) ? "restart" : "start"
    run "#{sudo} #{command} nginx"
  end
end

