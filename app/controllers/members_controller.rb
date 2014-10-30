class MembersController < ApplicationController
  autocomplete :user, :fullname, :full => true, :display_value => :zid_with_fullname, :extra_data => [:zid, :fullname], :scope => [:search_staff_by_zid_and_fullname]


  def get_autocomplete_items(parameters)
    items = User.search_by_zid_and_fullname(params[:term])    
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @member }
    end
  end

end
