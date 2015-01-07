class AssessmentAttribute < ActiveRecord::Base
  belongs_to :assessment_task
  belongs_to :graduate_attribute
  # attr_accessible :title, :body
end
