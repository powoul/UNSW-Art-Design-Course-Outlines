class AssessmentTaskResource < ActiveRecord::Base
  attr_accessible :resource, :order_number
  attr_accessible :technical_staff_attributes

  belongs_to :assessment_task
  has_many :users, :through => :members, :uniq => true
  has_one :technical_staff, :as => :associate, :class_name => "Member", :conditions => "members.role = 'TECHNICAL STAFF'", :dependent => :destroy
  
  accepts_nested_attributes_for :technical_staff, :allow_destroy => true, :reject_if => proc { |a| a["member_name"].blank? }

  before_validation :initialize_associate, :on => :create

  after_initialize :initialize_technical_staff

  validates_presence_of :resource, :technical_staff

  def initialize_associate
  	technical_staff.associate = self
  end

  def initialize_technical_staff
    technical_staff ||= Member.new(:role => "TECHNICAL STAFF")
  end

end
