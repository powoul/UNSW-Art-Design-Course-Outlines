module CoursesHelper
	def completed?(course)
		return (course.status.present? && course.status == "APPROVED") ? true : false
	end

	def weeks_list(course)
		return course.topics.all.reject { |s| s.week.blank? }.map {|t| t.date.strftime("%Y-%m-%d")}
	end
	
end