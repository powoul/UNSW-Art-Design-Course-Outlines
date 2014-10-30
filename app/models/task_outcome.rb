class TaskOutcome < ActiveRecord::Base
  attr_accessible :assessment_task_id, :course_learning_outcome_id
  belongs_to :assessment_task
  belongs_to :course_learning_outcome
end