# Author::    James Hill
# Copyright:: Copyright (c) 2011
#
# == Description:
# This library wraps the UNSW AD server and the ruby ldap library into an accessable place for
# my.cofa (http://my.cofa.unsw.edu.au) applications.

require 'ldap'

module UNSW
  HOST = Courseoutlines::Application::AD_CONFIG['host']
  USER_BASE = "OU=IDM_People,OU=IDM,DC=ad,DC=unsw,DC=edu,DC=au"
  DEFAULT_GROUP_BASE = "OU=OneUNSW,DC=ad,DC=unsw,DC=edu,DC=au"

  def self.connection
    # CACHE Connection so we don't need to rebind in the event we continue searching
    # unless @connection
      @connection = LDAP::Conn.new(HOST, LDAP::LDAP_PORT)
      @connection.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)
      @connection.set_option( LDAP::LDAP_OPT_SIZELIMIT, 500 )
      @connection.bind("#{Courseoutlines::Application::AD_CONFIG['ad_user']}@ad.unsw.edu.au", Courseoutlines::Application::AD_CONFIG['ad_password'])
    # end
    # @connection
  end

  def self.authenticate!(zid, password, faculty = nil)
    user = UNSW.authenticate(zid, password, faculty)
    user.nil? ? raise(InvalidAuthentication) : user
  end

  def self.authenticate(zid, password, faculty = nil)
    [zid, password].each {|each| return nil if each.nil? or each.empty?}

    # This is a handy backdoor if you're unable to talk to the UNSW AD
    return User.dummy if Rails.env.development? && zid == 'z1234567' && password == 'password'

    conn = LDAP::Conn.new(HOST, LDAP::LDAP_PORT)
    conn.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)

    begin
      conn.bind("#{zid}@ad.unsw.edu.au", password)
    rescue
      return nil
    end

    results = conn.search2(USER_BASE, LDAP::LDAP_SCOPE_SUBTREE, "(cn=#{zid})")
    Rails.logger.info "^^^^^^ results => #{results.inspect}"
    return nil if results.empty?

    user = UNSW::User.new(results[0], false, faculty)
    return user
  end

  def self.find_user(zid, faculty = nil)
    Rails.logger.info "&&&&&& in unsw.find_user: Faculty => #{faculty.inspect}"
    results = nil
    user = nil

    timer("UNSW AD: User #{zid} loaded in ") do
      # return Rails.env.development? ? UNSW::User.dummy : nil
      # Search for user via their zID.
      results = self.connection.search2(USER_BASE, LDAP::LDAP_SCOPE_SUBTREE, "(cn=#{zid})")

    # If results instantiate a new UNSW::User object with the RUBY-LDAP Entry
      user = results.any? ? UNSW::User.new(results.first, false, faculty) : nil
    end

    user
  end

  def self.timer(message, &block)
    start = Time.now
    yield
    finish = Time.now
    Rails.logger.info("\e[41m  #{message} #{finish-start} seconds  \e[0m")
  end

  def self.find_group(group)
    # TODO
  end

  #
  # UNSW::User represents the UNSW AD Entry of a User.
  #
  class User
    attr_accessor :ad_entry, :dn, :zid, :name, :first_name, :last_name, :email, :description, :dummy, :member_of, :groups, :groups_dn, :init_duration, :idm_classes, :idm_program

    def initialize(entry, dummy = false, faculty = nil)
      init_time = Time.now
      self.ad_entry = entry
      self.dummy = dummy
      self.dn = entry['dn'].first
      self.zid = entry['cn'].first
      self.name = entry['displayName'].first
      self.first_name = entry['givenName'].nil? ? '' : entry['givenName'].first
      self.last_name = entry['sn'].nil? ? '' : entry['sn'].first
      self.description = entry['description'].nil? ? '' : entry['description'].first
      self.email = entry['mail'].nil? ? '' : entry['mail'].first

      unless dummy
        group_base = faculty && !faculty.ad_group_base.blank? ? faculty.ad_group_base : DEFAULT_GROUP_BASE
        Rails.logger.info "USING #{group_base} , Faculty => #{faculty.inspect}"
        Rails.logger.info "USING #{group_base}"
        result = UNSW.connection.search2(group_base, LDAP::LDAP_SCOPE_SUBTREE, "(member:1.2.840.113556.1.4.1941:=#{self.dn})", 'name')
        self.groups = result.collect{|r|r['name']}.flatten
      end

      # find all the classes this user is in.
      self.idm_classes = entry['memberOf'].select{|dn| !dn[/^CN=IDM_CLS/].nil? }

      self.idm_program = entry['memberOf'].select{|dn| !dn[/^CN=IDM_PROG/].nil? }

      # calculate the initialization time
      self.init_duration = Time.now - init_time
    end

    def member_of?(group)
      return true if dummy
      self.groups.include?(group.to_s)
    end

    def User.dummy
      user = User.new({'dn' => [''], 'cn' => ['z3019631'], 'displayName' => ['James Hill'], 'mail' => ['fake@unsw.edu.au'], 'memberOf' => ['CFA_Staff'], 'description' => ['Totally Bad Ass']}, true)
      return user
    end

    def to_s
      "#{zid} (#{name}, #{email})"
    end
  end

  class InvalidAuthentication < StandardError
  end
end
