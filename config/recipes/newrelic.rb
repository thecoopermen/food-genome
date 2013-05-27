namespace :newrelic do
  task :add_apt_repo, :roles => :app do
    unless capture('ls /etc/apt/sources.list.d').include?('newrelic')
      put "deb http://apt.newrelic.com/debian newrelic non-free", "/tmp/newrelic.list"
      run "#{sudo} mv /tmp/newrelic.list /etc/apt/sources.list.d/"
      run "wget -q -O- http://download.newrelic.com/548C16BF.gpg | #{sudo} apt-key add -"
    end
  end
  before "deploy:install", "newrelic:add_apt_repo"

  desc "Install the latest relase of the New Relic system monitor"
  task :install, roles: :app do
    ensure_packages_installed("newrelic-sysmond")

    if capture("#{sudo} cat /etc/newrelic/nrsysmond.cfg").include?("REPLACE_WITH_REAL_KEY")
      config = File.read(File.join(File.dirname(__FILE__), '..', 'newrelic.yml'))
      config.match(/license_key:\s*'?([a-f0-9]+)'?/) do |md|
        run "#{sudo} nrsysmond-config --set license_key=#{md[1]}"
        run "#{sudo} /etc/init.d/newrelic-sysmond start"
      end
    end
  end
  after "deploy:install", "newrelic:install"
end

