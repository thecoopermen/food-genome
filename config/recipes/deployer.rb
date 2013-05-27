namespace :deployer do

  desc 'Create the deploy user'
  task :create do
    begin
      capture 'whoami'
    rescue Capistrano::ConnectionError
      with_user('root') do
        # create the deploy user
        run 'adduser --ingroup sudo --disabled-password deploy' do |channel, stream, data|
          channel.send_data "\n\n\n\n\nY\n"
        end
        run 'mkdir -p ~deploy/.ssh && chmod 700 ~deploy/.ssh && chown deploy:sudo ~deploy/.ssh'

        # create the deploy user's authorized_keys file
        key = `cat ~/.ssh/id_rsa.pub`.strip
        put key, '/home/deploy/.ssh/authorized_keys'
        run 'chmod 600 ~deploy/.ssh/authorized_keys && chown deploy:sudo ~deploy/.ssh/authorized_keys'

        # modify the sudoers file to allow the deploy user to sudo without a password
        run 'sed -i "s/%sudo\sALL=(ALL:ALL)\sALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/g" /etc/sudoers'

        # secure the root account so you can no longer log in as root
        run 'passwd -l root'
      end
    end
  end

  task :gemrc do
    content = 'gem: --no-rdoc --no-ri'
    unless capture("cat ~/.gemrc || echo 'no gemrc'").strip == content
      put content + "\n", './.gemrc'
    end
  end
  after 'deployer:create', 'deployer:gemrc'
end

before 'deploy:preinstall', 'deployer:create'
