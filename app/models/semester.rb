class Semester < ActiveRecord::Base
  attr_accessible :end, :mid_semester_break, :name, :non_teaching_week, :start, :year

  has_many :courses

  scope :search_by_name_and_year, lambda { |q|
   (q ? where(["name LIKE ? or year LIKE ? or concat(name, ', ', year) like ?", '%'+ q + '%', '%'+ q + '%','%'+ q + '%' ]).order(:year).limit(10)  : {})
 }

 def name_with_year
  	"#{name}, #{year}"
  end

end
