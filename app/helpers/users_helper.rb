module UsersHelper
  
  def gravatar_for(user, options = { :size => 50})
    gravatar_image_tag(user.email.downcase,
                       :alt => h(user.fname),
                       :class => 'gravatar',
                       :gravatar => options)
  end
  
  def toggle_family(user)
    #@user =  User.find(params[:id])
    if user.user_type.nil?
      return "1"  
    end
    
    @user_types = user.user_type.split('|')
    if (@user_types.include?("1"))
      @user_types.delete("1")
    else
      @user_types.push("1")
    end
    @user_types.join("|")
  end
  
  def toggle_friend(user)
    if user.user_type.nil?
      return "2"  
    end
    #@user =  User.find(params[:id])
    @user_types = user.user_type.split('|')
    if (@user_types.include?("2"))
      @user_types.delete("2")
    else
      @user_types.push("2")
    end
    @user_types.join("|")
  end
  
  def total_time_s(user, timespan)
    total_hours = user.total_time(timespan)
    hours = total_hours.to_i
    minutes = ((total_hours - hours.to_f) * 60).to_i
    time_s = ""
    if (hours > 0)
      time_s += pluralize(hours, "hour")
    end
    if (hours > 0 && minutes > 0)
      time_s += ", "
    end
    if (minutes > 0)
      time_s += pluralize(minutes, "minutes")
    end
    time_s
  end
  
end
