class UserMailer < ActionMailer::Base
  default :from => "no-reply@unsw.edu.au"
  
  def course_convenor(user, course)
  	@user = user
  	@course = course
  	mail(:to => @user.email, :subject => "Course Outline for #{course.code} has been created.") do |format|
      format.html
    end
  end

  def program_director(user, course)
  	@user = user
  	@course = course
  	mail(:to => @user.email, :subject => "Course Outline for #{course.code} requires your approval") do |format|
      format.html
    end
  end

  def technical_staff(user, course)
    @user = user
    @course = course
    mail(:to => @user.email, :subject => "Course Outline - Technical Staff") do |format|
      format.html
    end
  end


end
