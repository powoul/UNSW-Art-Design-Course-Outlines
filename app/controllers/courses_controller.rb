class CoursesController < ApplicationController
  #autocomplete :program, :description, :full => true, :display_value => :number_with_description, :extra_data => [:number, :description], :scopes => [:search_by_number_and_description], :where => { :status => true }
  
  # def get_autocomplete_items(parameters)
  #   items = Program.search_by_number_and_description(params[:term])  
  # end


  # GET /courses
  # GET /courses.json
  def index
    if !params[:category].present?
      @courses = Course.all
    elsif (params[:category] == 'convenor')
      @courses = []
      Course.all.each do |course|
        @courses << course if current_user.convenor?(course)
      end
    else
      @courses = []
      Course.all.each do |course|
        @courses << course if current_user.program_director?(course)
      end      
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])
    
    @resources_required = []
    @proficiencies_required = []
    @course.assessment_tasks.each do |task|
      task.assessment_task_resources.each do |resource|
        @resources_required << resource.resource
      end
      task.assessment_task_proficiencies.each do |proficiency|
        @proficiencies_required << proficiency.proficiency
      end
    end
    @resources_required = @resources_required.compact.uniq
    @proficiencies_required = @proficiencies_required.compact.uniq
    
    # @course_convenor = @course.members.where(:role => "CONVENOR").first
    # @teaching_staff = @course.members.where(:role => "TEACHING STAFF")

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        render :pdf => "#{@course.name}",
          :layout => 'authenticated.pdf',
          :show_as_html => params[:debug].present? && Rails.env.development?,
          :page_size    => 'A4',
          :dpi          => 177
      end
      format.json { render :json => @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    if current_user.admin? && Semester.count >= 1 
        @course = Course.new
        @course.convenor = Member.new(:role => 'CONVENOR')
        # @course.program_director = Member.new(:role => 'PROGRAM DIRECTOR')

        respond_to do |format|
          format.html # new.html.erb
          format.json { render :json => @course }
        end
    else
      respond_to do |format|
        unless current_user.admin?
          flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe 
        else
          flash[:error] = 'Please create a semester first and try again.'
        end 
        format.html { redirect_to courses_url }
        format.json { head :no_content }
      end      
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
    
    if !@course.teaching_strategy.present?
       @course.teaching_strategy = TeachingStrategy.new
    end


    if current_user.admin? || current_user.convenor?(@course) || current_user.program_director?(@course)
      respond_to do |format|
          format.html # new.html.erb
          format.json { render :json => @course }
        end
    else
      respond_to do |format|
        flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe
        format.html { redirect_to course_url(@course) }
        format.json { head :no_content }
      end
    end

    # if !@course.topics.present?
    #   @course.topics =  create_topics
    # end
    
    # @course.expectation = Expectation.new
    # if @course.lecturers.empty?
    #   @course.lecturers << Member.new(:role => 'LECTURER')
    # end
    # if @course.course_improvements.empty?
    #   @course.course_improvements << CourseImprovement.new
    # end
    # if @course.assessments.empty? 
    #   @course.assessments << Assessment.new
    # end
    #@course_convenor = @course.members.where(:role => "CONVENOR").first
    #@affiliated_program = @course.affiliated_program
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])
    @course.status = Course::STATUS[params[:status]]
    
    respond_to do |format|
      if @course.save
        # Suppress email notification for now. 
        # UserMailer.course_convenor(@course.convenor.user, @course).deliver

        format.html { redirect_to @course, :notice => 'Course was successfully created.' }
        format.json { render :json => @course, :status=> :created, :location => @course }
      else
        @course.convenor ||= Member.new(:role => 'CONVENOR')
        # @course.program_director ||= Member.new(:role => 'PROGRAM DIRECTOR')
        format.html { render :action => "new" }
        format.json { render :json => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])
    
    @course.status = Course::STATUS[params[:status]]
    @course.attributes = params[:course]
    validate = params[:status] && (params[:status] == "SUBMIT FOR APPROVAL" || params[:status] == "APPROVE")
    
    respond_to do |format|
      if @course.save(:validate => validate)
        if @course.status == "SUBMIT"
          # Suppress email notification for now.
          # UserMailer.program_director(@course.program_director.user, @course).deliver
        end
        format.html { redirect_to course_path(@course, :section_id => params[:section_id]), :notice => 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end

  def create_topics
    topics = []
    semester = @course.semester
    if semester.blank?
      return nil
    end
    week = semester.start
    week_number = 1

    while week <= semester.end do
      if week == semester.non_teaching_week
        topics << Topic.new(:week => week_number, :date => week, :topic_name => "Non-Teaching Week", :bgcolor => "grey")
        week_number = week_number + 1
        week = week + 7
      elsif week == semester.mid_semester_break
        topics << Topic.new(:date => week, :topic_name => "Mid-Semester Break", :bgcolor => "grey")
        week = week + 7
      else
        topics << Topic.new(:week => week_number, :date => week, :bgcolor => "white")
        week_number = week_number + 1
        week = week + 7
      end
    end
    
    return topics
  end
end
