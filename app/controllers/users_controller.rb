class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]
  before_filter :signed_in,:only => [:signup, :create]
  before_filter :same_user_type, :only => [:show]
  
  def signup
    @user = User.new
    @title = "Sign Up"
  end

  def index
    @title = "All Users"
    if current_user.admin?
      @users = User.paginate(:page => params[:page])
    elsif current_user.user_type.nil?
      @users = [ current_user ]
    else
      @viewable_user_types = current_user.user_type.split('|')
      # ensure they can see people in both groups...
      @viewable_user_types.push("1|2")
      @viewable_user_types.push("2|1")
      @users = User.find(:all, :conditions =>
                        ["user_type IN (?) or admin=?", @viewable_user_types, true]).paginate(:page => params[:page])
    end
  end

  def show
    @user = User.find(params[:id])
    @activities = @user.activities.paginate(:page => params[:page], :per_page => 10)
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
    #@user.secret_word = "angusbeef"
    if (!params[:user].nil?)
      params[:user].merge({:user_type => @user.user_type})
    end
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      if current_user.admin?
        redirect_to users_path
      else
        redirect_to @user
      end
    elsif current_user.admin?
      if User.update_all({:user_type => params[:user_type]}, {:id => @user.id})
        flash[:success] = "User updated."        
      end
      redirect_to users_path
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
      redirect_to(root_path) unless current_user?(@user) or current_user.admin?
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def same_user_type
      @user = User.find(params[:id])
      redirect_to(root_path) unless (!current_user.nil? && current_user.can_view_user?(@user))
      #if (!current_user.admin?)
      #  if (current_user.user_type.nil? || @user.user_type.nil?)
      #    redirect_to(root_path)
      #  else
      #    redirect_to(root_path) unless current_user.user_type.can_view_user?(@user)
      #  end      
      #end
    end

end
