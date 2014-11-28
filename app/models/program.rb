class Program < ActiveRecord::Base
  attr_accessible :description, :number, :active
  attr_accessible :director_attributes

  has_many :courses
  has_many :users, :through => :members, :uniq => true
  has_one :director, :as => :associate, :class_name => "Member", :conditions => "members.role = 'PROGRAM DIRECTOR'", :dependent => :destroy

  accepts_nested_attributes_for :director, :allow_destroy => true, :reject_if => proc { |a| a["member_name"].blank? }

  scope :search_by_number_and_description, lambda { |q|
   (q ? where(["number LIKE ? or description LIKE ? or concat(number, ' - ', description) like ?", '%'+ q + '%', '%'+ q + '%','%'+ q + '%' ]).order(:description).limit(10)  : {})
 }

 before_validation :initialize_associate, :on => :create

 define_index do
  	indexes number, :sortable => true
  	indexes description, :sortable => true

    set_property :min_infix_len => 2
  end

 def number_with_description
  	"#{number} - #{description}"
 end

 def initialize_associate
  if director.present?
    director.associate = self
  end
 end

end
