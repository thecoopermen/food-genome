set_default :ruby_version,    File.read(File.join(File.dirname(__FILE__), '..', '..', '.ruby-version')).strip
set_default :rbenv_bootstrap, "bootstrap-ubuntu-12-04"

namespace :rbenv do
  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install, roles: :app do
    ensure_packages_installed("curl", "git-core")

    # don't do anything if the requested version of ruby is already installed
    next if capture("rbenv versions || echo 'rbenv is not installed'").include?(ruby_version)

    # if rbenv has been installed the phrase 'rbenv' should be in the deploy user's bashrc
    unless capture("cat ~/.bashrc").include?('rbenv')
      # install rbenv and adjust the deploy user's bashrc file
      run "curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash"
      put File.read(File.expand_path('../templates/rbenv_bashrc_additions.sh', __FILE__)), "/tmp/rbenvrc"
      run "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
      run "mv ~/.bashrc.tmp ~/.bashrc"

      # get the local environment set up so rbenv will work
      run %q{export PATH="$HOME/.rbenv/bin:$PATH"}
      run %q{eval "$(rbenv init -)"}
      run "rbenv #{rbenv_bootstrap}"
    end

    # get the required ruby version installed using rvm
    run "rbenv install #{ruby_version}"
    run "rbenv global #{ruby_version}"
    run "gem install bundler --no-ri --no-rdoc"
    run "rbenv rehash"
  end
  before "deploy:install", "rbenv:install"
end

