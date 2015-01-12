class AssessmentAttribute < ActiveRecord::Base
  attr_accessible :assessment_task_id, :graduate_attribute_id

  belongs_to :assessment_task
  belongs_to :graduate_attribute
end
