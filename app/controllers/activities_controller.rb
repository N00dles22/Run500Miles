class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :edit, :update]
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  
  def new
    @title = "Log a Run"
    @activity = current_user.activities.build(params[:activity])
  end
  
  def create
    @activity = current_user.activities.build(params[:activity])
    if (@activity.save)
      flash[:success] = "Activity logged!"
      redirect_to root_path
    else
      @feed_items = []
      render 'new'
    end
  end
  
  def edit
    @title = "Edit Activity"
    @activity = Activity.find(params[:id])
  end
  
  def show
    @activity = Activity.find(params[:id])
  end
  
  def index
    @activities = current_user.activities
  end
  
  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      flash[:success] = "Activity updated."
      redirect_back_or root_path
    else
      @title = "Edit Activity"
      render 'edit'
    end
  end

  def destroy
	@activity = Activity.find(params[:id])
    @activity.destroy
	
	respond_to do |format|
	  format.html { 
		flash[:notice] = "Activity deleted!"
		redirect_back_or root_path 
	  }
	  format.js { 		
	    @user_info = render_to_string(:partial => 'shared/user_info', :locals => {:object => current_user}) 
	  }
	end
    #
    #redirect_back_or root_path
  end
  
  private
    def authorized_user
      @activity = current_user.activities.find_by_id(params[:id])
      redirect_to root_path if @activity.nil?
    end
end
