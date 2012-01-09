
module DateUtils

  def year
    { :start => Date.new(2011, 12, 04), :end => Date.new(2012, 12, 03) }
  end
  
  def current_week
    wstart = Date.today - Date.today.wday
  end
  
  def week_end(week_start)
    wend = week_start + 6
  end
  
  def weeks
    week_arr = [year[:start]]
    for i in 1..51
	  week_arr.push(year[:start] + i*7)
	end
	return week_arr
  end
end