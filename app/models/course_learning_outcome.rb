class CourseLearningOutcome < ActiveRecord::Base
  belongs_to :course
  has_many :task_outcomes, :dependent => :destroy
  has_many :assessment_tasks, :through => :task_outcomes

  attr_accessible :name#, :order_number
end
