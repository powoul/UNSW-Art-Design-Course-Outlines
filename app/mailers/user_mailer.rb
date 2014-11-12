class UserMailer < ActionMailer::Base
  default :from => "no-reply@unsw.edu.au"

  def technical_staff(user, course)
  	@user = User.find_by_zid('z3486533') #user
  	@course = course
  	mail(:to => @user.email, :subject => "Course Outline - Technical Staff")
  end

  def course_convenor(user, course)
  	@user = User.find_by_zid('z3486533') #user
  	@course = course
  	mail(:to => @user.email, :subject => "Course Outline - Course Convenor")
  end

  def program_director(user, course)
  	@user = User.find_by_zid('z3486533') #user
  	@course = course
  	mail(:to => @user.email, :subject => "Course Outline - Program Director")
  end

end
