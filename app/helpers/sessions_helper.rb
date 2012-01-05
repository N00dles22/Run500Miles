module SessionsHelper
  
  def sign_in(user, persist)
    if (persist == "yes")
	  new_week = (7 - Date.today.wday).days.from_now
	  #expire_date = DateTime.new(new_week.year, new_week.month, new_week.day)
	  cookies.signed[:remember_token] = {:value => [user.id, user.salt], :expires => new_week}
	else
	  session[:remember_token] = user.id
	end
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
	
	if (@current_user.nil?)
	  @current_user ||= session[:remember_token] &&
	  User.find_by_id(session[:remember_token])
	end
	
	return @current_user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    session[:remember_token] = nil
    self.current_user = nil
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access unless signed_in?
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page"
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  private
  
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] = nil
    end
    
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
