class GraduateAttributesController < ApplicationController
  # GET /graduate_attributes
  # GET /graduate_attributes.json
  def index
    @graduate_attributes = GraduateAttribute.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @graduate_attributes }
    end
  end

  # GET /graduate_attributes/1
  # GET /graduate_attributes/1.json
  def show
    @graduate_attribute = GraduateAttribute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @graduate_attribute }
    end
  end

  # GET /graduate_attributes/new
  # GET /graduate_attributes/new.json
  def new
    if current_user.admins?
      @graduate_attribute = GraduateAttribute.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @graduate_attribute }
      end
    else
      respond_to do |format|
        flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe
        format.html { redirect_to graduate_attributes_url }
        format.json { head :no_content }
      end
    end
  end

  # GET /graduate_attributes/1/edit
  def edit
    if current_user.admins?
      @graduate_attribute = GraduateAttribute.find(params[:id])

      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @graduate_attribute }
      end
    else
      respond_to do |format|
        flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe
        format.html { redirect_to graduate_attributes_url }
        format.json { head :no_content }
      end
    end
  end

  # POST /graduate_attributes
  # POST /graduate_attributes.json
  def create
    @graduate_attribute = GraduateAttribute.new(params[:graduate_attribute])

    respond_to do |format|
      if @graduate_attribute.save
        format.html { redirect_to @graduate_attribute, :notice => 'Graduate attribute was successfully created.' }
        format.json { render :json => @graduate_attribute, :status => :created, :location => @graduate_attribute }
      else
        format.html { render :action => "new" }
        format.json { render :json => @graduate_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /graduate_attributes/1
  # PUT /graduate_attributes/1.json
  def update
    @graduate_attribute = GraduateAttribute.find(params[:id])

    respond_to do |format|
      if @graduate_attribute.update_attributes(params[:graduate_attribute])
        format.html { redirect_to @graduate_attribute, :notice => 'Graduate attribute was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @graduate_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /graduate_attributes/1
  # DELETE /graduate_attributes/1.json
  def destroy
    if current_user.superadmin?
      @graduate_attribute = GraduateAttribute.find(params[:id])
      @graduate_attribute.destroy

      respond_to do |format|
        format.html { redirect_to graduate_attributes_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        flash[:error] = 'You have been denied access to this page because you do not have the right access to this page. If you believe that a mistake has been made, please contact <a href="mailto:h.samani@unsw.edu.au">h.samani@unsw.edu.au</a>.'.html_safe
        format.html { redirect_to graduate_attributes_url }
        format.json { head :no_content }
      end
    end
  end
end
