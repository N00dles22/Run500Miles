include DateUtils

class Statistics
  attr_reader :user
  
  START_DATE = Date.new(2011, 12, 04)
  END_DATE = Date.new(2012, 12, 03)
  
  def initialize(user)
	self.user = user
	#self.mileage_week = Stat.new(user, "mileage", "week")
	#self.mileage_year = Stat.new(user, "mileage", "year")
	#self.time_week = Stat.new(user, "time", "week")
	#self.time_year = Stat.new(user, "time", "year")
  end
  
  
  
  def get_chart(chart_type, timespan)
    
  end
  
  private
    def ideal_progress(timespan)
	  sdate = START_DATE
	  edate = END_DATE
	  
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