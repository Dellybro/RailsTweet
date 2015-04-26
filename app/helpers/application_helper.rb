module ApplicationHelper
	def full_title(page_title = '')
		base_title = "TwitterClone made by Travis Delly"
		page_title.empty? ? base_title : "#{page_title} | #{base_title}"
	end
end
