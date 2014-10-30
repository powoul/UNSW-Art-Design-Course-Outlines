class Semester < ActiveRecord::Base
  attr_accessible :end, :mid_semester_break, :name, :non_teaching_week, :start, :year

  has_many :courses

end
