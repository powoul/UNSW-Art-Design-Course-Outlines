require 'rubygems'
require 'active_record'
require 'mysql2'
require 'net/ssh/gateway'

namespace :import do

	desc "Import staff list from IDM database. Options: RAILS_ENV=production"
  # USAGE
  # ================
  # rake import:staff_list
  # RAILS_ENV=production rake import:staff

  task :staff => [:environment] do

    User.destroy_all

		gateway = Net::SSH::Gateway.new('cfaplmman01', 'z3486533_sa')		
		puts "true" if gateway.active?
		port = gateway.open('127.0.0.1', 3306, 3307)

		child  = fork do
	    class CofaStaff < ActiveRecord::Base
	      establish_connection(
	        :adapter  => "mysql2",
	        :host     => "127.0.0.1",
	        :username => "root",
	        :password => "Hq4Rz1qwe1313",
	        :database => "idm_data",
	        :port     => 3307
	      )
        self.table_name = 'idm_data.user'
		  end

      users = CofaStaff.joins('JOIN staff on staff.id = user.id')
      puts users.count 
      cnt_update = 0
      cnt_insert = 0
      users.each do |u|
        if (user = User.find_by_zid(u.username))
          user.update_attributes(:fullname => u.full_name, :email => u.email)
          cnt_update = cnt_update + 1
          puts u.username
        else
          User.create(:zid => u.username, :fullname => u.full_name, :email => u.email)
          cnt_insert = cnt_insert + 1
        end
      end
      puts "#{cnt_insert} created, #{cnt_update} updated."
    end

    puts "child: #{child}"
    
    Process.wait
    gateway.close(port)    
	end

  desc "Import programs list from IDM database. Options: RAILS_ENV=production"
  # USAGE
  # ================
  # rake import:programs
  # RAILS_ENV=production rake import:programs
  task :programs => [:environment] do
    Program.destroy_all
    gateway = Net::SSH::Gateway.new('cfaplmman01', 'z3486533_sa')   
    puts "true" if gateway.active?
    port = gateway.open('127.0.0.1', 3306, 3307)
    child = fork do
      class Pathway < ActiveRecord::Base
        establish_connection(
          :adapter  => "mysql2",
          :host     => "127.0.0.1",
          :username => "root",
          :password => "Hq4Rz1qwe1313",
          :database => "idm_data",
          :port     => 3307
        )
        self.table_name = 'idm_data.program'
        end
        programs = Pathway.all
        puts programs.count
        cnt_update = 0
        cnt_insert = 0
        programs.each do |u|
          if (Program.find_by_number(u.number))
            cnt_update = cnt_update + 1
            puts u.number
          else
            Program.create(:number => u.number, :description => u.description)
            cnt_insert = cnt_insert + 1
          end
        end
        puts "#{cnt_insert} created, #{cnt_update} updated."
      end # fork
      puts "child: #{child}"  
      Process.wait  
      gateway.close(port)
  end

end