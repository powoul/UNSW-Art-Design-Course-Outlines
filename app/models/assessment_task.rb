class AssessmentTask < ActiveRecord::Base
  belongs_to :course
  attr_accessible :due, :feedback, :synopsis, :title, :weighting

  attr_accessible :criteria_attributes
  attr_accessible :assessment_task_proficiencies_attributes
  attr_accessible :assessment_task_resources_attributes
  attr_accessible :task_outcomes_attributes

  has_many :criteria, :dependent => :destroy
  has_many :assessment_task_proficiencies, :dependent => :destroy
  has_many :assessment_task_resources, :dependent => :destroy
  has_many :task_outcomes
  has_many :course_learning_outcomes, :through => :task_outcomes

  accepts_nested_attributes_for :criteria, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :assessment_task_resources, :allow_destroy => true
  accepts_nested_attributes_for :assessment_task_proficiencies, :allow_destroy => true
  accepts_nested_attributes_for :task_outcomes, :allow_destroy => true

  validates_presence_of :title
end
