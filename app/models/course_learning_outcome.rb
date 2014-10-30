class CourseLearningOutcome < ActiveRecord::Base
  belongs_to :course
  has_many :task_outcomes
  has_many :assessment_tasks, :through => :task_outcomes

  attr_accessible :name
end
