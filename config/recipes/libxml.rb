namespace :libxml do
  desc "Install latest libxml (to support libraries such as nokogiri)"
  task :install, roles: :app do
    ensure_packages_installed "libxml2-dev", "libxslt1-dev"
  end
  after "deploy:install", "libxml:install"
end

