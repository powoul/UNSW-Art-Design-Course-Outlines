require 'bundler/capistrano'
require 'thinking_sphinx/deploy/capistrano'

set :application, "courseoutlines"
set :domain, 'my.cofa.unsw.edu.au'
set :port, 4567
set :deploy_to, "/data/sites/my.cofa.unsw.edu.au/apps/#{application}"
set :use_sudo, true

server domain, :app, :web, :db, :primary => true
set :user, "z3486533_sa"
set :scm, :git
set :scm_vebrose, false
set :deploy_via, :copy
set :repository,  "ssh://git.cofa.unsw.edu.au/data/git/my.cofa.unsw.edu.au-courseoutlines.git"

# SETUP

after "deploy:setup", :roles => :app do
  run "mkdir -p #{shared_path}/assets"
  run "mkdir -p #{shared_path}/bundle"
  run "mkdir -p #{shared_path}/config"
  run "mkdir -p #{shared_path}/db/sphinx"
  run "mkdir -p #{shared_path}/sessions"
  
  sudo "chown -R deploy:tl_svr_linux_users #{shared_path}/../../#{application}"
  sudo "chmod -R 664 #{shared_path}/../../#{application}"
  sudo "chmod -R a+x #{shared_path}/../../#{application}"
end

# UPDATE CODE
after  "deploy:update_code", :roles => :app do

	# Application config files
	run "ln -s #{shared_path}/config/database.yml   #{release_path}/config/database.yml"
	run "ln -s #{shared_path}/config/ad.yml         #{release_path}/config/ad.yml"
	run "ln -s #{shared_path}/config/sphinx.yml     #{release_path}/config/sphinx.yml"

	# Application shared files
	run "ln -nfs #{shared_path}/assets                          #{release_path}/assets"
	run "ln -nfs #{shared_path}/bundle                          #{release_path}/vendor/bundle"
	run "ln -nfs #{shared_path}/db/sphinx                       #{release_path}/db/sphinx"
	run "ln -nfs #{shared_path}/log                             #{release_path}/log"
	run "ln -nfs #{shared_path}/pids                            #{release_path}/pids"
	run "ln -nfs #{shared_path}/sessions                        #{release_path}/tmp/sessions"
	run "ln -nfs #{shared_path}/system                          #{release_path}/system"

  thinking_sphinx.configure
  thinking_sphinx.index
  #thinking_sphinx.start

end


after "bundle:install", :roles => :app do
  sudo "chown -R deploy:tl_svr_linux_users #{shared_path}/bundle"
  sudo "chmod -R 664 #{shared_path}/bundle"
  sudo "chmod -R a+x #{shared_path}/bundle" 
end

after "deploy:assets:precompile", :roles => :app do
  sudo "chown -R deploy:tl_svr_linux_users #{shared_path}/assets/*"
  sudo "chmod -R o+rX #{shared_path}/assets/*"
end

before "deploy:symlink", :roles => :app do
  sudo "chown -R deploy:tl_svr_linux_users #{release_path} #{shared_path}/db"
  sudo "chmod -R 664 #{release_path} #{shared_path}/db"
  sudo "chmod -R a+x #{release_path} #{shared_path}/db"
  sudo "chown -R deploy:tl_svr_linux_users #{release_path}/.bundle"
  sudo "chown -R deploy:tl_svr_linux_users #{release_path}/*"
end

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  %w(start restart).each { |name| task name, :roles => :app do passenger.restart end }
end

load 'deploy/assets'
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end