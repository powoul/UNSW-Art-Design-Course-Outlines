module CoursesHelper
	def completed?(course)
		return (course.status.present? && course.status == "APPROVED") ? true : false
	end

	def weeks_list(course)
		return course.topics.all.reject { |s| s.week.blank? }.map {|t| "Week " + t.week.to_s } #{|t| t.date.strftime("%Y-%m-%d")}
	end

	def text_color(status)
		case status
		when "DRAFT"
			return "red"
		when "SUBMITTED"
			return "orange"
		when "APPROVED"
			return "green"
		end
	end
	
end