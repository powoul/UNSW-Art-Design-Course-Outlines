class Program < ActiveRecord::Base
  attr_accessible :description, :number

  has_many :courses

  scope :search_by_number_and_description, lambda { |q|
   (q ? where(["number LIKE ? or description LIKE ? or concat(number, ' - ', description) like ?", '%'+ q + '%', '%'+ q + '%','%'+ q + '%' ]).order(:description).limit(10)  : {})
 }

 define_index do
  	indexes number, :sortable => true
  	indexes description, :sortable => true

    set_property :min_infix_len => 2
  end

 def number_with_description
  	"#{number} - #{description}"
  end

end
