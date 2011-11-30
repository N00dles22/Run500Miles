class UsersController < ApplicationController
  def signup
    @title = "Sign Up"
  end

  def show
    @user = User.find(params[:id])
  end

end
