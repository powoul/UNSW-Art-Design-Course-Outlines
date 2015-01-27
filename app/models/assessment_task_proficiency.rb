class AssessmentTaskProficiency < ActiveRecord::Base
  belongs_to :assessment_task
  attr_accessible :proficiency#, :order_number

  validates_presence_of :proficiency
end
