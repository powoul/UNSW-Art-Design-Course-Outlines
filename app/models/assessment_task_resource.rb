class AssessmentTaskResource < ActiveRecord::Base
  belongs_to :assessment_task
  attr_accessible :resource
end
