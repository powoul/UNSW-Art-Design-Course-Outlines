class Course < ActiveRecord::Base

  attr_accessible :code, :name, :semester_id, :semester_name, :program_id, :program_name, :units_of_credit, :teaching_times_and_locations, :online_course_support,
      :parallel_teaching, :summary, :course_aims, :assessment, :resources
  
  attr_accessible :convenor_attributes
  # attr_accessible :program_director_attributes
  attr_accessible :lecturers_attributes
  attr_accessible :course_learning_outcomes_attributes
  attr_accessible :teaching_strategy_attributes
  attr_accessible :members
  attr_accessible :course_improvements_attributes
  attr_accessible :topics_attributes
  attr_accessible :assessment_tasks_attributes

  has_many :users, :through => :members, :uniq => true
  has_many :lecturers, :as => :associate, :class_name => "Member", :conditions => "members.role = 'LECTURER'", :dependent => :destroy
  has_one :convenor, :as => :associate, :class_name => "Member", :conditions => "members.role = 'CONVENOR'", :dependent => :destroy
  # has_one :program_director, :as => :associate, :class_name => "Member", :conditions => "members.role = 'PROGRAM DIRECTOR'", :dependent => :destroy
  has_many :course_learning_outcomes, :dependent => :destroy, :order => "order_number ASC"
  has_one :teaching_strategy
  has_many :course_improvements, :dependent => :destroy
  has_many :topics, :dependent => :destroy
  has_many :assessment_tasks, :dependent => :destroy
  has_many :members, :as => :associate, :class_name => "Member"
  belongs_to :semester
  belongs_to :program

  accepts_nested_attributes_for :lecturers, :allow_destroy => true, :reject_if => proc { |a| a["member_name"].blank? && a['id'].blank? }
  accepts_nested_attributes_for :convenor, :allow_destroy => true, :reject_if => proc { |a| a["member_name"].blank? && a['id'].blank? }
  # accepts_nested_attributes_for :program_director, :allow_destroy => true, :reject_if => proc { |a| a["member_name"].blank? }
  accepts_nested_attributes_for :course_learning_outcomes, :allow_destroy => true, :reject_if => proc { |a| a["name"].blank? }
  accepts_nested_attributes_for :teaching_strategy, :allow_destroy => true
  accepts_nested_attributes_for :topics, :allow_destroy => true
  accepts_nested_attributes_for :assessment_tasks, :allow_destroy => true
  accepts_nested_attributes_for :course_improvements, :allow_destroy => true, :reject_if => proc { |a| a["description"].blank? }
  accepts_nested_attributes_for :members
  
  before_create :create_topics

  before_validation :initialize_associate, :on => :create

  validates_presence_of :code, :name, :semester, :units_of_credit, :summary, :convenor, :program, :on => :create
  validates_presence_of :teaching_times_and_locations, :online_course_support, :parallel_teaching, :course_aims, :on => :update
  validates :resources, :presence => {:message => "Resources for students can't be blank."}, :on => :update
  validates_uniqueness_of :code, :scope => [:semester_id], :message => "Course already exists for this semester" 
  validate :uniqueness_of_learning_outcomes, :number_of_learning_outcomes, :on => :update
  validate :uniqueness_of_lecturers, :presence_of_convenor_attributes, :on => :update
  validate :presence_of_teaching_staff_attributes, :on => :update
  validate :number_of_assessment_tasks, :on => :update
  validate :task_total_wighting, :on => :update
  validate :presence_of_program_director, :on => :update
  validates_associated :assessment_tasks, :message => "Error in assessment tasks"

  STATUS = {
    'SUBMIT FOR APPROVAL'  => 'SUBMITTED',
    'SAVE'    => 'DRAFT',
    'APPROVE' => 'APPROVED'
  }

  define_index do
    indexes code
    indexes updated_at, :sortable => true
    indexes [program.number, program.description], :as => :program_code
    indexes [users.username, users.full_name], :as => :user_id

    set_property :min_infix_len => 2
  end

  def semester_name
    semester.present? ? semester.try(:name) + ', ' + semester.try(:year).to_s : ''
  end 

  def semester_name=(name)
    self.semester = Semester.search_by_name_and_year(name).first if name.present?
  end

  def program_name
    program.present? ? program.try(:number).to_s + ' - ' + program.try(:description) : ''
  end

  def program_name=(name)
    self.program = Program.search_by_number_and_description(name).first if name.present?
  end

  def initialize_associate
    if lecturers.present?
  	 lecturers.each { |p| p.associate = self }
    end

    if convenor.present?
      convenor.associate = self
    end

    # if program_director.present?
    #   program_director.associate = self
    # end

    if members.present?
      members.each { |p| p.associate = self }
    end
  end

  def create_topics
    topics = []
    semester = self.semester
    if semester.blank?
      return nil
    end
    week = semester.start
    week_number = 1

    while week <= semester.end do
      if week == semester.non_teaching_week
        topics << Topic.new(:week => week_number, :date => week, :topic_name => "Non-Teaching Week", :bgcolor => "#D8D8D8")
        week_number = week_number + 1
        week = week + 7
      elsif week == semester.mid_semester_break
        topics << Topic.new(:date => week, :topic_name => "Mid-Semester Break", :bgcolor => "#D8D8D8")
        week = week + 7
      else
        topics << Topic.new(:week => week_number, :date => week, :bgcolor => "white")
        week_number = week_number + 1
        week = week + 7
      end
    end
    
    self.topics = topics
  end

  private

  def uniqueness_of_learning_outcomes
    if self.course_learning_outcomes.present?
      names = self.course_learning_outcomes.reject(&:marked_for_destruction?).map(&:name)
      if names.compact.uniq.count != self.course_learning_outcomes.reject(&:marked_for_destruction?).map(&:name).size
        errors.add :course_learning_outcomes, 'Duplicate learning outcomes. Please remove the duplicates.'
      end
    end
  end

  def number_of_learning_outcomes
    names = self.course_learning_outcomes.reject(&:marked_for_destruction?).map(&:name)
    if names.compact.uniq.count > 5
      errors.add :course_learning_outcomes, 'Maximum <strong>five</strong> learning outcomes are allowed.'.html_safe
    end
    if names.compact.uniq.count < 1
      errors.add :course_learning_outcomes, 'No student learning outcome has been added.'.html_safe
    end
  end

  def number_of_assessment_tasks
    if !self.assessment_tasks.present? || self.assessment_tasks.reject(&:marked_for_destruction?).size < 2
      errors.add :assessment_tasks, 'At least 2 assessment tasks are required.'.html_safe
    elsif self.assessment_tasks.reject(&:marked_for_destruction?).size > 3
      errors.add :assessment_tasks, 'Maximum <strong>three</strong> assessment tasks are allowed.'.html_safe
    end
  end

  def uniqueness_of_lecturers
    names = self.lecturers.reject(&:marked_for_destruction?).map(&:member_name)
    if names.compact.uniq.count != self.lecturers.reject(&:marked_for_destruction?).map(&:member_name).size
      errors.add :lecturers, 'Duplicate teaching staff. Please remove the duplicates.'
    end
  end

  def presence_of_convenor_attributes
    convenor = self.convenor
    if convenor.present?
      if convenor.phone_number.blank?
        errors.add :convenor, "Phone number can't be blank"
      end

      if convenor.room.blank?
        errors.add :convenor, "Phone number can't be blank"
      end

      if convenor.consultation_times.blank?
        errors.add :convenor, "consultation times can't be blank"
      end
    end
  end

  def presence_of_teaching_staff_attributes
    staff = self.lecturers
    staff.each do |s|
      if s.consultation_times.blank?        
        errors.add :lecturers, "consultation times can't be blank"
      end
    end
  end

  def task_total_wighting
    if self.assessment_tasks.present?
      weight = 0
      self.assessment_tasks.reject(&:marked_for_destruction?).map(&:weighting).each do |w|
        weight = weight + w
      end
      if weight > 100
        errors.add :assessment_tasks, "Total weighting can not be greatear than 100%"
      end
    end
  end

  def presence_of_program_director
    if self.program.present? && self.program.director.blank?
      errors.add :course, "Prgoram director is undefined for the affiliated program"
    end
  end

end
