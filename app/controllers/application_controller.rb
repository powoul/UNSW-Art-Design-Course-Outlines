# Author::    Hamid Dehghani Samani
# Copyright:: Copyright (c) 2014
# == Description:
# Standard Rails application controller with added private methods

require 'will_paginate/array'

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate, :validate_group, :load_user

  helper_method :current_user, :current_ad_user
  
  # Default layout for aithenticated users
  layout 'authenticated'
  

  def authenticate
  	CASClient::Frameworks::Rails::Filter.filter(self)
  end

  def validate_group
  end

  def load_user
    zID = session[:current_user]
    logger.info "LOADING USER WITH ZID : #{zID}"    
    @current_user = UNSW.find_user(zID)
    logger.info "LOADED USER WITH ZID : #{current_user.zid}"
  end

  def current_ad_user 
    return @current_ad_user if defined?(@current_ad_user)
    @current_ad_user = UNSW.find_user(session[:current_user])    
    @current_ad_user
  end 

  # def current_user
  #   @current_user
  # end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_by_zid(session[:current_user])
    logger.info "current_user => #{@current_user}"
    unless @current_user
      uni_user = UNSW.find_user(session[:current_user])
      if uni_user 
        @current_user = User.new
        @current_user.zid  = uni_user.zid
        @current_user.fullname = uni_user.name
        @current_user.save!
      else
        raise ActiveRecord::RecordNotFound
      end
    end    
    return @current_user
  end
end
