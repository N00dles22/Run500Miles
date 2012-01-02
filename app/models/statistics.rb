include DateUtils

class Statistics
  attr_accessor :user, :mileage_week, :mileage_year, :time_week, :time_year
  
  START_DATE = Date.new(2011, 12, 04)
  END_DATE = Date.new(2012, 12, 03)
  
  def initialize(user)
	self.user = user
	self.mileage_week = Stat.new(user, "mileage", "week")
	self.mileage_year = Stat.new(user, "mileage", "year")
	self.time_week = Stat.new(user, "time", "week")
	self.time_year = Stat.new(user, "time", "year")
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
	
	c_opts = {:width => 400, :height => 240, :title => c_title, :is3D => true}
	
	if (!opts.empty?)
	  c_opts.merge(opts)
	end
	
	p_chart = GoogleVisualr::Interactive::PieChart.new(c_data, c_opts)
	
	#the following goes in the html.erb file
	#<div id='ychart'>
	#</div>
	#<%= render_chart(@ychart, 'ychart') %>
  end
    
  private
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
	conditions = ''
	total = 0.0
	
	if (timespan == "week")
	  conditions = ' AND activity_date >= ' + (Date.today - Date.today.wday).to_s
	end
	
	if (stat_type == "mileage")
	  total = user.total_miles(timespan)
	elsif (stat_type == "time")
	  total = user.total_time(timespan)
	end
	
	case stat_type
	  when "mileage"
		self.run = user.activities.sum(:distance,
										:conditions => ['activity_type = 1' + conditions])
		self.walk = user.activities.sum(:distance,
										:conditions => ['activity_type = 2' + conditions])
		self.both = [total - run - walk, 0.0].max
	  when "time"
		self.run = user.activities.sum(:hours,
									   :conditions => ['activity_type = 1' + conditions]).to_f +
            (user.activities.sum(:minutes,
								 :conditions => ['activity_type = 1' + conditions]).to_f/60)
		self.walk = user.activities.sum(:hours,
									   :conditions => ['activity_type = 2' + conditions]).to_f +
            (user.activities.sum(:minutes,
								 :conditions => ['activity_type = 2' + conditions]).to_f/60)
		self.both = [total - run - walk, 0.0].max
	end
  end
end