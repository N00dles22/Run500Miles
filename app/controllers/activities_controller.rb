class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @activity = current_user.activities.build(params[:activity])
    if (@activity.save)
      flash[:success] = "Activity logged!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @activity.destroy
    flash[:notice] = "Activity deleted!"
    redirect_back_or root_path
  end
  
  private
    def authorized_user
      @activity = current_user.activities.find_by_id(params[:id])
      redirect_to root_path if @activity.nil?
    end
end
