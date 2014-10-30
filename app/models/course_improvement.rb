class CourseImprovement < ActiveRecord::Base
  belongs_to :course
  attr_accessible :description
end
