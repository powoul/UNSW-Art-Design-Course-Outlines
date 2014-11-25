class User < ActiveRecord::Base
  attr_accessible :zid, :fullname, :email, :phone_number, :room

  has_many :members
  belongs_to :affiliated_program

  ROLES = ['CONVENOR', 'TEACHING STAFF']

  define_index  do
  	indexes fullname, :sortable => true
  	indexes zid, :sortable => true
  end

  scope :search_by_zid_and_fullname, lambda { |q| 
  	(q ? where(["zid LIKE ? or fullname LIKE ? or concat(zid, ' - ', fullname) LIKE ?", '%' + q + '%', '%' + q + '%', '%' + q + '%']).order(:fullname).limit(10) : {})
  }

  def zid_with_fullname
  	"#{zid} - #{fullname}"
  end

  def admin?
    self.role == 'ADMIN'
  end

  def convenor?(course)
    self == course.convenor.user
    # course..each do |m|
    #   return true if (self == m.user && m.role == "CONVENOR")
    # end
    # false
  end

  def program_director?(course)
    if course.program.director.present?
      return true if self == course.program.director.user
    end
    false
  end

end