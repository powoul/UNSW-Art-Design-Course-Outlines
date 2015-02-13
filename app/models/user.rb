class User < ActiveRecord::Base
  attr_accessible :zid, :fullname, :email, :phone_number, :room, :role

  has_many :members
  belongs_to :affiliated_program

  ROLES = ['TECHNICAL STAFF', 'ADMIN', 'SUPERADMIN']

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

  def superadmin?
    self.role == "SUPERADMIN"
  end

  def admins?
    self.role == "ADMIN" || self.role == "SUPERADMIN"
  end
  
  def convenor?(course)
    self == course.convenor.user
  end

  def program_director?(course)
    if course.program.director.present?
      return true if (self == course.program.director.user)
    end
    false
  end

  def convenor_or_superadmin?(course)
    (self == course.convenor.user) || (self.role == "SUPERADMIN")
  end

  def convenor_or_director_or_superadmin?(course)
    (self == course.convenor.user) || (course.program.director.present? && self == course.program.director.user) || (self.role == "SUPERADMIN")
  end

end