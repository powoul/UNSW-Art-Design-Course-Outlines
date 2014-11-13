class AssessmentTask < ActiveRecord::Base
  
  belongs_to :course
  attr_accessible :title, :due, :weighting, :synopsis, :feedback

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
  accepts_nested_attributes_for :assessment_task_resources, :allow_destroy => true, :reject_if => proc { |a| a["resource"].blank? }
  accepts_nested_attributes_for :assessment_task_proficiencies, :allow_destroy => true, :reject_if => proc { |a| a["proficiency"].blank? }
  accepts_nested_attributes_for :task_outcomes, :allow_destroy => true, :reject_if => proc { |a| a["course_learning_outcome_id"].blank? }

  validates_presence_of :title, :due, :weighting, :synopsis, :feedback

  validate :number_of_criteria
  validates_associated :criteria, :message => "Error in assessment criteria"
  validate :uniqueness_of_task_outcomes

  def week_name
    
  end

  private

  def number_of_criteria
    if self.criteria.reject(&:marked_for_destruction?).size > 5
      errors.add :criteria, 'Maximum 5 criteria is accepted.'
    end
  end

  def uniqueness_of_task_outcomes
    ids = self.task_outcomes.reject_if(&:marked_for_destruction?).map(&:course_learning_outcome_id)
    if ids.compact.uniq.count != self.task_outcomes.reject_if(&:marked_for_destruction?).map(&:course_learning_outcome_id).size
      errors.add :self, 'Duplicate course learning outcomes. Please remove the duplicates.'
    end
  end

end
