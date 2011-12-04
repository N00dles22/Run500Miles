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
      sign_in @user
      flash[:success] = "Welcome! Now you're ready to run 500 miles!"
      redirect_to @user
    else
      @title = "Sign Up"
      @user.password = ""
      @user.password_confirmation = ""
      @user.secret_word = ""
      render 'signup'
    end
  end

end
