module ApplicationHelper
	def icon(selector, additional_text = nil, inverse = false)
		"<i class=\"icon-#{selector} #{'icon-white' if inverse}\"></i> #{additional_text}".html_safe
	end
end
