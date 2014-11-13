class UserMailer < ActionMailer::Base
  default :from => "no-reply@unsw.edu.au"
  
  def course_convenor(user, course)
  	@user = user
  	@course = course
  	mail(:to => @user.email, :subject => "Course Outline - Course Convenor") do |format|
      format.html { render 'course_convenor.html.erb' }
      format.text { render :text => 'course_convenor.text.erb' }
    end
  end

  def program_director(user, course)
  	@user = user
  	@course = course
  	mail(:to => @user.email, :subject => "Course Outline - Program Director") do |format|
      format.html { render 'program_director.html.erb' }
      format.text { render :text => 'program_director.text.erb' }
    end
  end

  def technical_staff(user, course)
    @user = user
    @course = course
    mail(:to => @user.email, :subject => "Course Outline - Technical Staff") do |format|
      format.html { render 'technical_staff.html.erb' }
      format.text { render :text => 'technical_staff.text.erb' }
    end
  end


end
