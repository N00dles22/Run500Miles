module DateUtils
  YEAR_START = Date.new(2011, 12, 04)
  YEAR_END = Date.new(2012, 12, 03)
  
  def current_week
    wstart = Date.today - Date.today.wday
  end
  
  def week_end(week_start)
    wend = week_start + 6
  end
  
  def weeks
    week_arr = [YEAR_START]
    for i in 1..51
	  week_arr.push(YEAR_START + i*7)
	end
	return week_arr
  end
end