class AssessmentTask < ActiveRecord::Base
  
  belongs_to :course
  attr_accessible :title, :weighting, :synopsis, :feedback, :graduate_attribute_ids

  attr_accessible :criteria_attributes
  attr_accessible :assessment_task_proficiencies_attributes
  attr_accessible :assessment_task_resources_attributes
  attr_accessible :task_outcomes_attributes
  attr_accessible :assessment_dates_attributes

  has_many :criteria, :dependent => :destroy#, :order => "created_at ASC, order_number ASC"
  has_many :assessment_task_proficiencies, :dependent => :destroy#, :order => "order_number ASC"
  has_many :assessment_task_resources, :dependent => :destroy#, :order => "order_number ASC"
  has_many :task_outcomes, :dependent => :destroy#, :order => "order_number ASC"
  has_many :course_learning_outcomes, :through => :task_outcomes
  has_many :assessment_dates, :dependent => :destroy#, :order => "order_number ASC"
  has_and_belongs_to_many :graduate_attributes, :join_table => 'assessment_attributes'

  accepts_nested_attributes_for :criteria, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :assessment_task_resources, :allow_destroy => true, :reject_if => proc { |a| a["resource"].blank? }
  accepts_nested_attributes_for :assessment_task_proficiencies, :allow_destroy => true, :reject_if => proc { |a| a["proficiency"].blank? }
  accepts_nested_attributes_for :task_outcomes, :allow_destroy => true, :reject_if => proc { |a| a["course_learning_outcome_id"].nil? }
  accepts_nested_attributes_for :assessment_dates, :allow_destroy => true, :reject_if => :all_blank

  validates_presence_of :title, :weighting, :synopsis, :feedback, :assessment_dates

  # Suppress this validation for now
  #validate :number_of_criteria

  # Suppress this validation for now
  #validate :maximum_weighting
  
  validates_associated :criteria, :message => "Error in assessment criteria"
  validates_associated :assessment_task_resources, :message => "Error in resources"
  validate :uniqueness_of_task_outcomes

  def week_name
    
  end

  private

  def maximum_weighting
    if self.weighting.present? && self.weighting > 65
      errors.add :weighting, "can not be greater than 65%"
    end
  end

  def number_of_criteria
    if self.criteria.reject(&:marked_for_destruction?).size > 5
      errors.add :criteria, 'maximum 5 criteria is accepted'
    end
  end

  def uniqueness_of_task_outcomes
    ids = self.task_outcomes.reject(&:marked_for_destruction?).map(&:course_learning_outcome_id)
    if ids && (ids.compact.uniq.count != self.task_outcomes.reject(&:marked_for_destruction?).map(&:course_learning_outcome_id).size)
      errors.add :task_outcomes, 'duplicate course learning outcomes. Please remove the duplicates.'
    end
  end

end
