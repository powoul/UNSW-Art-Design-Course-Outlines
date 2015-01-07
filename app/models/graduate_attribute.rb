class GraduateAttribute < ActiveRecord::Base
  has_many :assessment_tasks, :through => :assessment_attributes
  has_many :assessment_attributes
  
  attr_accessible :name

  validates_presence_of :name
end
