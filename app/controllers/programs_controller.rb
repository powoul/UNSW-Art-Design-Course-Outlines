class ProgramsController < ApplicationController
  # GET /programs
  # GET /programs.json
  def index
    per_page = params[:per_page] || 40
    params[:order] ||= 'number'
    if params[:search].present?
      @programs = Program.search params[:search], :order => "#{params[:order]} ASC", :page => params[:page], :per_page => per_page
    else
      @programs = Program.order(params[:order]).paginate(:page => params[:page], :per_page => per_page)
    end 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @programs }
    end
  end

  # GET /programs/1
  # GET /programs/1.json
  def show
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @program }
    end
  end

  # GET /programs/new
  # GET /programs/new.json
  def new
    if current_user.admin?
      @program = Program.new
      @program.director = Member.new(:role => 'PROGRAM DIRECTOR')

      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @program }
      end
    else
      respond_to do |format|
        flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe
        format.html { redirect_to programs_url }
        format.json { head :no_content }
      end
    end
  end

  # GET /programs/1/edit
  def edit
    if current_user.admin?
      @program = Program.find(params[:id])

      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @program }
      end
    else
      respond_to do |format|
        flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe
        format.html { redirect_to program_url(@course) }
        format.json { head :no_content }
      end
    end
  end

  # POST /programs
  # POST /programs.json
  def create
    @program = Program.new(params[:program])

    respond_to do |format|
      if @program.save
        format.html { redirect_to @program, :notice => 'Program was successfully created.' }
        format.json { render :json => @program, :status => :created, :location => @program }
      else
        format.html { render :action => "new" }
        format.json { render :json => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /programs/1
  # PUT /programs/1.json
  def update
    @program = Program.find(params[:id])

    respond_to do |format|
      if @program.update_attributes(params[:program])
        format.html { redirect_to @program, :notice => 'Program was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.json
  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to programs_url }
      format.json { head :no_content }
    end
  end
end
