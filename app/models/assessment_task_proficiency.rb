class AssessmentTaskProficiency < ActiveRecord::Base
  belongs_to :assessment_task
  attr_accessible :proficiency
end
