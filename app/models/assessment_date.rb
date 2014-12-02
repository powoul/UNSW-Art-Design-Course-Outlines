class AssessmentDate < ActiveRecord::Base
  attr_accessible :due, :description, :order_number

  belongs_to :assessment_task
  
end
