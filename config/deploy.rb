set :application, "railsforum"
set :repository,  "git@github.com:frankploss/railsforum.git"
set :deploy_to,   "/srv/www/railsforum"
set :scm, :git

role :web, "biafra.fqxp.de"
role :app, "biafra.fqxp.de"
role :db,  "biafra.fqxp.de", :primary => true
#role :db,  "your slave db-server here"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :default_environment, {
#  'PATH' => '/bin:/usr/bin',
#  'RUBY_VERSION' => '1.9.2',
#  'GEM_HOME' => '/usr/local/rvm/gems/ruby-1.9.2-p290',
  'GEM_PATH' => '~/.rvm/gems/ruby-1.9.2-p318:~/.rvm/gems/ruby-1.9.2-p318@global'
#  'BUNDLE_PATH' => '/usr/local/rvm/gems/ruby-1.9.2-p290'
}

set :bundle_cmd, 'source $HOME/.bash_profile && bundle'

# see https://rvm.beginrescueend.com/integration/capistrano/
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2'        # Or whatever env you want it to run in.
set :rvm_type, :user  # Don't use system-wide RVM

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:update_code', :precompile_assets
after 'deploy:update_code', :bundle_install
after 'deploy:update_code', :link_db_config

desc 'install the necessary prerequisites'
task :bundle_install, :roles => [:app, :web] do
  #run "cd #{release_path} && echo $PATH && bundle install"
  run "cd #{release_path} && echo $PATH && bundle install"
end

desc 'link database configuration into current release'
task :link_db_config, :roles => :db do
  run "ln -sf #{deploy_to}/database.yml #{File.join(release_path, 'config')}"
end

desc 'precompile assets'
task :precompile_assets, :roles => :web do
  run "cd #{release_path} && bundle exec rake assets:precompile"
end
