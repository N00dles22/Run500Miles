class UsersController < ApplicationController
  def signup
    @user = User.new
    @title = "Sign Up"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.fname
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome! Now you're ready to run 500 miles!"
      redirect_to @user
    else
      @title = "Sign Up"
      render 'signup'
    end
  end

end
