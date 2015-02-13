class ParametersController < ApplicationController
  # GET /parameters
  # GET /parameters.json
  def index
    @parameters = Parameter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @parameters }
    end
  end

  # GET /parameters/1
  # GET /parameters/1.json
  def show
    @parameter = Parameter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @parameter }
    end
  end

  # GET /parameters/new
  # GET /parameters/new.json
  def new
    if current_user.admins?
      @parameter = Parameter.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @parameter }
      end
    else
      flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe
      respond_to do |format|
        format.html { redirect_to parameters_url }
        format.json { head :no_content }
      end
    end
  end

  # GET /parameters/1/edit
  def edit
    if current_user.admins?
      @parameter = Parameter.find(params[:id])

      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @parameter }
      end
    else
      flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe
      
      respond_to do |format|
        format.html { redirect_to parameters_url }
        format.json { head :no_content }
      end
    end
  end

  # POST /parameters
  # POST /parameters.json
  def create
    @parameter = Parameter.new(params[:parameter])

    respond_to do |format|
      if @parameter.save
        format.html { redirect_to @parameter, :notice => 'Parameter was successfully created.' }
        format.json { render :json => @parameter, :status => :created, :location => @parameter }
      else
        format.html { render :action => "new" }
        format.json { render :json => @parameter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /parameters/1
  # PUT /parameters/1.json
  def update
    @parameter = Parameter.find(params[:id])

    respond_to do |format|
      if @parameter.update_attributes(params[:parameter])
        format.html { redirect_to @parameter, :notice => 'Parameter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @parameter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /parameters/1
  # DELETE /parameters/1.json
  def destroy
    if current_user.superadmin?
      @parameter = Parameter.find(params[:id])
      @parameter.destroy

      respond_to do |format|
        format.html { redirect_to parameters_url, :notice => "Parameter was successfully deleted." }
        format.json { head :no_content }
      end
    else
      flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe
      respond_to do |format|
        format.html { redirect_to parameters_url }
        format.json { head :no_content }
      end  
    end
  end
end
