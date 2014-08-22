
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
set :repository,  "ssh://git.cofa.unsw.edu.au/data/git/my.cofa.unsw.edu.au-staffportal.git"

set :scm, :subversion


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