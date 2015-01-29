class Topic < ActiveRecord::Base
  belongs_to :course
  attr_accessible :date, :tasks_due, :topic_name, :week, :bgcolor, :course_id
end
