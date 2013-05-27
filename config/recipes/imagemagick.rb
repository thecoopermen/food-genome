namespace :imagemagick do
  desc "Install latest imagemagick (to support CarrierWave image processing)"
  task :install, roles: :app do
    ensure_packages_installed "libmagickcore-dev", "libmagickwand-dev"
  end
  after "deploy:install", "imagemagick:install"
end

