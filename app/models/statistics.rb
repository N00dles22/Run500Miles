include DateUtils

class Statistics
  attr_reader :user, :mileage_week, :mileage_year, :time_week; :time_year
  
  START_DATE = Date.new(2011, 12, 04)
  END_DATE = Date.new(2012, 12, 03)
  
  def initialize(user)
	self.user = user
	self.mileage_week = Stat.new(user, "mileage", "week")
	self.mileage_year = Stat.new(user, "mileage", "year")
	self.time_week = Stat.new(user, "time", "week")
	self.time_year = Stat.new(user, "time", "year")
  end
  
  def get_chart(chart_type, timespan)
    
  end
      # Graph stuff
    #@percentages = @user.percentages("year")
    #@yearly_pie = GoogleVisualr::DataTable.new
    
    #@yearly_pie.new_column('string', 'Activity Type')
    #@yearly_pie.new_column('number', 'Mileage Logged')
    
    #@yearly_pie.add_rows(3)
    
    #@yearly_pie.set_cell(0, 0, 'Ran')
    #@yearly_pie.set_cell(0, 1, @percentages[:mrun])
    #@yearly_pie.set_cell(1, 0, 'Walked')
    #@yearly_pie.set_cell(1, 1, @percentages[:mwalk])
    #@yearly_pie.set_cell(2, 0, 'Ran and Walked')
    #@yearly_pie.set_cell(2, 1, @percentages[:mboth])
    
    #chart_opts = { :width => 400, :height => 240, :title => 'Yearly', :is3D => true,
    #                :colors => ['#66FF66', '#66FFFF', '#CCFF99']}
    
    #@ychart = GoogleVisualr::Interactive::PieChart.new(@yearly_pie, chart_opts)
	
	#the following goes in the html.erb file
	#<div id='ychart'>
	#</div>
	#<%= render_chart(@ychart, 'ychart') %>
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
  attr_reader :run, :walk, :both
  
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
		self.both = [@total - run - walk, 0.0].max
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