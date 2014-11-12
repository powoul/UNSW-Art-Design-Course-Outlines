class AssessmentTaskProficiency < ActiveRecord::Base
  belongs_to :assessment_task
  attr_accessible :proficiency

  validates_presence_of :proficiency
end
