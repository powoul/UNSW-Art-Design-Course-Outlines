class Member < ActiveRecord::Base
  attr_accessible :member_name, :role, :consultation_times, :phone_number, :room

  belongs_to :user
  belongs_to :associate, :polymorphic => true
  belongs_to :course
  delegate :phone_number, :phone_number=, :room, :room=, :email, :email=, :to => :user, :allow_nil => true

  def member_name
  	user.present? ? user.try(:zid) + ' - ' + user.try(:fullname) : ''  	
  end

  def member_name=(name)
  	self.user = User.search_by_zid_and_fullname(name).first if name.present?
  end

  def member_fullname
  	user.present? ? user.try(:fullname) : ''
  end
end