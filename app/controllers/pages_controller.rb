class PagesController < ApplicationController
  def home
    @title = "Home"
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
  
  def signup
    @title = "Sign Up"
  end
  
  def help
    @title = "Help"
  end

end
