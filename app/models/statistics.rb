include DateUtils

class Statistics
  attr_accessor :user
  
  START_DATE = Date.new(2011, 12, 04)
  END_DATE = Date.new(2012, 12, 03)
  
  def initialize(user)
	self.user = user
	# leave commented out; improves speed because we 
	# perform these actions when we need them
	#self.mileage_week = Stat.new(user, "mileage", "week")
	#self.mileage_year = Stat.new(user, "mileage", "year")
	#self.time_week = Stat.new(user, "time", "week")
	#self.time_year = Stat.new(user, "time", "year")
  end
  
  def mileage_week
    mw = Stat.new(user, "mileage", "week")
  end
  
  def mileage_year
    my = Stat.new(user, "mileage", "year")
  end
  
  def time_week
    tw = Stat.new(user, "time", "week")
  end
  
  def time_year
    ty = Stat.new(user, "time", "year")
  end
  
  #def get_weekday_activity_bar_chart(timespan, opts = {})
 # 	c_opts = {:width => 400, :height => 240, :title => c_title, :is3D => true}
#	
#	if (!opts.empty?)
#	  c_opts.merge(opts)
#	end
#	
#	chart = GoogleVisualr::Interactive::PieChart.new(c_data, c_opts)
  #end
  
  def get_weekday_breakdown_bar_chart(timespan, opts = {})
    acts = []
	if (timespan == "week")
	  acts = user.activities.all
	else
	  acts = user.activities.all
	end
	# indices: [sun, mon, tue, wed, thur, fri, sat]
	wdaycount = [0, 0, 0, 0, 0, 0, 0]
	acts.each do |a|
	  wdaycount[a.activity_date.wday] += 1
	end
	
	c_data = GoogleVisualr::DataTable.new
	c_data.new_column('string', 'Week Day')
	c_data.new_column('number', 'Activities Logged')
	
	c_data.add_row(['Sun', wdaycount[0]])
	c_data.add_row(['Mon', wdaycount[1]])
	c_data.add_row(['Tues', wdaycount[2]])
	c_data.add_row(['Wed', wdaycount[3]])
	c_data.add_row(['Thurs', wdaycount[4]])
	c_data.add_row(['Fri', wdaycount[5]])
	c_data.add_row(['Sat', wdaycount[6]])
	
	c_opts = {:width => 370, :height => 240, :title => 'Weekday Activity Breakdown', 
	          :legend => { :position => 'none' },
	          :hAxis => { :title => 'Day of the Week', :slantedText => true, :slantedTextAngle => 30 },
			  :vAxis => { :title => 'Activities Logged'}}
	
	if (!opts.empty?)
	  c_opts.merge!(opts)
	end
	
	chart = GoogleVisualr::Interactive::ColumnChart.new(c_data, c_opts)
	
  end
  
  def get_speed_line_chart(opts = {})
    c_data = GoogleVisualr::DataTable.new
	c_data.new_column('date', 'Date')
	c_data.new_column('number', 'Run Speed (mph)')
	#c_data.new_column('string', 'title1')
	#c_data.new_column('string', 'text1')
	c_data.new_column('number', 'Walk Speed (mph)')
	#c_data.new_column('string', 'title2')
	#c_data.new_column('string', 'text2')
	c_data.new_column('number', 'Run-Walk Speed (mph)')
	#c_data.new_column('string', 'title3')
	#c_data.new_column('string', 'text3')
	
	a = user.activities.reverse
	lrun = 0.0
	lwalk = 0.0
	lboth = 0.0
	a.each do |act|
	  speed = act.distance/(act.hours + act.minutes/60)
	  case act.activity_type
	   when 1
		  lrun = speed
		when 2
		  lwalk = speed
		when 3
		  lboth = speed
	  end
	  c_data.add_row([act.activity_date, 
	      @speed,
	      lwalk, 
	      lboth
		])
	end
	
	c_opts = { :title => 'Activity Speed', :width => 660, :height => 300, :curveType => 'function', :hAxis => { :title => 'Activity Date' }, :vAxis => { :title => 'Speed (mph)' }}
	if (!opts.empty?)
	  c_opts.merge!(opts)
	end
	
    chart = GoogleVisualr::Interactive::LineChart.new(c_data, c_opts)	
  end
  
  def get_pie_chart(chart_type, timespan, opts = {})
    case chart_type
	  when "mileage"
	    c_title = "Mileage Logged"
	    if (timespan == "week")
		  c_title += " (week)"
		  stat_data = mileage_week
		else
		  c_title += " (year)"
		  stat_data = mileage_year
		end
	  when "time"
	    c_title = "Time Logged"
		if (timespan == "week")
		  c_title += " (week)"
		  stat_data = time_week
		else
		  c_title += " (year)"
		  stat_data = time_year
		end
	end
	
    c_data = GoogleVisualr::DataTable.new
	
	c_data.new_column('string', 'Activity Type')
	c_data.new_column('number', c_title)
	
	c_data.add_rows(3)
	
	c_data.set_cell(0, 0, 'Ran')
	c_data.set_cell(0, 1, stat_data.run)
	c_data.set_cell(1, 0, 'Walked')
	c_data.set_cell(1, 1, stat_data.walk)
	c_data.set_cell(2, 0, 'Ran and Walked')
	c_data.set_cell(2, 1, stat_data.both)
	
	c_opts = {:width => 300, :height => 240, :title => c_title, :is3D => true}
	
	if (!opts.empty?)
	  c_opts.merge!(opts)
	end
	
	chart = GoogleVisualr::Interactive::PieChart.new(c_data, c_opts)
	
	#the following goes in the html.erb file
	#<div id='ychart'>
	#</div>
	#<%= render_chart(@ychart, 'ychart') %>
  end
  
  def get_weeks
    weeks
  end
  #private
    def ideal_progress(timespan)
	  case timespan
	    when "week"
		  ideal_p = format("%0.2f", ((Date.today.wday + 1).to_f * 10)/ 7).to_f
		when "year"
		  ideal_p = format("%0.2f", ((Date.today - START_DATE).to_f * 500)/365).to_f
	  end
	  return ideal_p
	end
	
	
	
end

class Stat
  attr_accessor :run, :walk, :both
  
  def initialize(user, stat_type, timespan)
	startdate = year[:start]
	total = 0.0
	
	if (timespan == "week")
	  startdate = current_week
	end
	
	if (stat_type == "mileage")
	  total = user.total_miles(timespan)
	elsif (stat_type == "time")
	  total = user.total_time(timespan)
	end
	
	case stat_type
	  when "mileage"
		self.run = user.activities.sum(:distance,
										:conditions => ['activity_type = 1 AND activity_date >= ?', startdate])
		self.walk = user.activities.sum(:distance,
										:conditions => ['activity_type = 2 AND activity_date >= ?', startdate])
		self.both = [total - run - walk, 0.0].max
	  when "time"
		self.run = user.activities.sum(:hours,
									   :conditions => ['activity_type = 1 AND activity_date >= ?', startdate]).to_f +
            (user.activities.sum(:minutes,
								 :conditions => ['activity_type = 1 AND activity_date >= ?', startdate]).to_f/60)
		self.walk = user.activities.sum(:hours,
									   :conditions => ['activity_type = 2 AND activity_date >= ?', startdate]).to_f +
            (user.activities.sum(:minutes,
								 :conditions => ['activity_type = 2 AND activity_date >= ?', startdate]).to_f/60)
		self.both = [total - run - walk, 0.0].max
	end
  end
end