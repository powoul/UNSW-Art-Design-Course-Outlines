class Course < ActiveRecord::Base

  attr_accessible :code, :name, :semester_id, :program_id, :program_name, :units_of_credit, :teaching_times_and_locations, :online_course_support,
      :parallel_teaching, :summary, :course_aims, :teaching_philosophy, :assessment, :resources
  
  attr_accessible :convenor_attributes
  attr_accessible :program_director_attributes
  attr_accessible :lecturers_attributes
  attr_accessible :course_learning_outcomes_attributes
  attr_accessible :teaching_strategy_attributes
  attr_accessible :members
  attr_accessible :course_improvements_attributes
  attr_accessible :topics_attributes
  attr_accessible :assessment_tasks_attributes
  # attr_accessible :semesters_attributes

  has_many :users, :through => :members, :uniq => true
  has_many :lecturers, :as => :associate, :class_name => "Member", :conditions => "members.role = 'LECTURER'", :dependent => :destroy
  has_one :convenor, :as => :associate, :class_name => "Member", :conditions => "members.role = 'CONVENOR'", :dependent => :destroy
  has_one :program_director, :as => :associate, :class_name => "Member", :conditions => "members.role = 'PROGRAM DIRECTOR'", :dependent => :destroy
  has_many :course_learning_outcomes, :dependent => :destroy
  has_one :teaching_strategy
  has_many :course_improvements, :dependent => :destroy
  has_many :topics, :dependent => :destroy
  has_many :assessment_tasks, :dependent => :destroy
  has_many :members, :as => :associate, :class_name => "Member"
  belongs_to :semester
  belongs_to :program

  accepts_nested_attributes_for :lecturers, :allow_destroy => true, :reject_if => proc { |a| a["member_name"].blank? }
  accepts_nested_attributes_for :convenor, :allow_destroy => true, :reject_if => proc { |a| a["member_name"].blank? }
  accepts_nested_attributes_for :program_director, :allow_destroy => true, :reject_if => proc { |a| a["member_name"].blank? }
  accepts_nested_attributes_for :course_learning_outcomes, :allow_destroy => true, :reject_if => proc { |a| a["name"].blank? }
  accepts_nested_attributes_for :teaching_strategy, :allow_destroy => true
  accepts_nested_attributes_for :topics, :allow_destroy => true
  accepts_nested_attributes_for :assessment_tasks, :allow_destroy => true#, :reject_if => proc { |a| a["title"].blank? }
  accepts_nested_attributes_for :course_improvements, :allow_destroy => true
  #accepts_nested_attributes_for :semesters
  accepts_nested_attributes_for :members
  
  before_validation :initialize_associate, :on => :create

  validates_presence_of :code, :name, :semester_id, :units_of_credit, :summary
  validates_presence_of :convenor, :program_director
  #validate :presence_of_course_convenor
  validates_uniqueness_of :code, :scope => [:semester_id], :message => "Course already exists for this course"
  
  before_create :create_topics

  define_index do
    indexes code
    indexes updated_at, :sortable => true
    indexes [program.number, program.description], :as => :program_code
    indexes [users.username, users.full_name], :as => :user_id

    set_property :min_infix_len => 2
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

    if program_director.present?
      program_director.associate = self
    end

    if members.present?
      members.each { |p| p.associate = self }
    end
  end

  def presence_of_course_convenor
    
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

end
