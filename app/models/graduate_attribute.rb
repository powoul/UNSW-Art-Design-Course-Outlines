class GraduateAttribute < ActiveRecord::Base
  has_and_belongs_to_many :assessment_attributes, :join_table => 'assessment_attributes'
  
  attr_accessible :name

  validates_presence_of :name
end
