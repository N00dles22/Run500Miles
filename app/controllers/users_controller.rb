class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  before_filter :signed_in,:only => [:signup, :create]
  
  def signup
    @user = User.new
    @title = "Sign Up"
  end

  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @activities = @user.activities.paginate(:page => params[:page])
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
  
  def edit
    #@user = User.find(params[:id])
    @title = "Edit User"
  end
  
  def update
    @user = User.find(params[:id])
    @user.secret_word = "angusbeef"
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit User"
      @user.password = ""
      @user.password_confirmation = ""
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if (current_user?(@user))
      flash[:error] = "You may not destroy yourself"
    else
      User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    end
    
    redirect_to users_path
  end
  
  private
    
    def signed_in
      redirect_to(root_path) unless !signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
