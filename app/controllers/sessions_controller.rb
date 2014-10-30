class SessionsController < ApplicationController
	def destroy
		session[:user] = nil
		CASClient::Frameworks::Rails::Filter.logout(self)
	end
end