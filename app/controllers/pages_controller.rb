class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @activity = Activity.new if signed_in?
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def profile
    @title = "Profile"
  end

  def log_run
    @title = "Log Your Run"
  end

  def login
    @title = "Login"
  end

  def contact
    @title = "Contact Info"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end

end
