class TeachingStrategy < ActiveRecord::Base
  belongs_to :course
  attr_accessible :blended_online, :blended_online_description, :lectures, :lectures_description, :seminars, :seminars_description, :studio, :studio_description, :tutorials, :tutorials_description, :teaching_philosophy

  validates_presence_of :teaching_philosophy
end
