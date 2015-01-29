class Semester < ActiveRecord::Base
  attr_accessible :end, :mid_semester_break, :name, :non_teaching_week, :start, :year

  has_many :courses

  scope :search_by_name_and_year, lambda { |q|
   (q ? where(["name LIKE ? or year LIKE ? or concat(name, ', ', year) like ?", '%'+ q + '%', '%'+ q + '%','%'+ q + '%' ]).order(:year).limit(10)  : {})
 }

 def name_with_year
  	"#{name}, #{year}"
 end

 def update_courses_topics

 	self.courses.each do |course|

	    if course.topics.blank?
	      course.create_topics
	    else
	    	week = self.start
		    week_number = 1
			while week <= self.end do
				unless week == self.mid_semester_break		      
				    unless (existing_topic = course.topics.find(:first, :conditions => { :week => week_number })).present?
						new_topic = Topic.new(:week => week_number, :date => week, :bgcolor => "white", :course_id => course.id)
					    new_topic.save				    
				    end			    
		      		week_number = week_number + 1
		      	end		      	
		      	week = week + 7
		    end
		    course.topics.where("date > ?", self.end).each do |topic|
		    	topic.destroy
		    end
	    end	    
 	end
 end

end
