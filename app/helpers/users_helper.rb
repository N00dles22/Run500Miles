module UsersHelper
  
  def gravatar_for(user, options = { :size => 50})
    gravatar_image_tag(user.email.downcase,
                       :alt => h(user.fname),
                       :class => 'gravatar',
                       :gravatar => options)
  end
  
  def total_miles(user, timespan)
    case timespan
    when "year"
      total = user.activities.sum(:distance)
    when "week"
      total = user.activities.sum(:distance,
                                  :conditions => ['activity_date >= ?',
                                                  (Date.today - Date.today.wday)])
    end
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
  
  def miles_left(user, timespan)
    total = timespan == "year" ? 500 : 10
    m_left = format("%0.2f", [total - total_miles(user, timespan), 0].max).to_f
  end
  
  def total_time_s(user, timespan)
    total_hours = total_time(user, timespan)
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
  
  def total_time(user, timespan)
    case timespan
    when "year"
      total_hours = user.activities.sum(:hours)
      total_minutes = user.activities.sum(:minutes)
      total = total_hours.to_f + (total_minutes.to_f/60)
    when "week"
      total_hours = user.activities.sum(:hours,
                                        :conditions => ['activity_date >= ?', (Date.today - Date.today.wday)])
      total_minutes = user.activities.sum(:minutes,
                                        :conditions => ['activity_date >= ?', (Date.today - Date.today.wday)])
      total = total_hours.to_f + (total_minutes.to_f/60)
    end
    
  end
  
end
