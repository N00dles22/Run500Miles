#require 'yaml'

module ApplicationHelper
  
  def ideal_progress (timespan)
    Statistics::ideal_progress(timespan)
  end
  
  def progress_bar(object, timespan)
    if (timespan == "year")
	  Utilities::UI.progress_bar(object.total_miles("year"), :ideal_progress => ideal_progress("year"), :bar_max => 500, :width => 200, :height => 15)
	else
	  Utilities::UI.progress_bar(object.total_miles("week"), :ideal_progress => ideal_progress("week"), :bar_max => 10, :width => 200, :height => 15)
	end
  end
  
  def js_array_string(fullArray, excludeItem)
  
    inner = fullArray.collect { |item| "\'" + item + "\'" unless item  == excludeItem}.delete_if { |item| item.nil? }.join(", ")
	return "[" + inner + "]"
  end
  
  # get the quote of the week
  def qotw
    q_content = Configuration.find_by_key('quote-content')
	q_source = Configuration.find_by_key('quote-source')
    { :content => q_content.nil? ? '' : q_content.value, :source => q_source.nil? ? '' : q_source.value }
  end
  
  def logo
    image_tag("logo.png", :alt => "Run 500 Miles", :class => "round")
  end
  
  # Return a title on a per-page basis
  def title
    base_title = "Run 500 Miles"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def monthly_theme
	case Date.today.month
	  when 1
	    "months/january"
	  when 2
	    "months/february"
	  when 3
	    "months/march"
	  when 4
	    "months/april"
	  when 5
	    "months/may"
	  when 6
	    "months/june"
	  when 7
	    "months/july"
	  when 8
	    "months/august"
	  when 9
	    "months/september"
	  when 10
	    "months/october"
	  when 11
	    "months/november"
	  when 12
	    "months/december"
	end
  end
  
  def jquery_ui_theme
    jquery_theme = "jquery_ui/" + Configuration.find_by_key('jquery-ui-theme').value + "/jquery-ui-1.8.18.custom"
	
	if (!File.exists?("public/stylesheets/" + jquery_theme + ".css"))
	  return "jquery_ui/smoothness/jquery-ui-1.8.18.custom"
	else
	  return jquery_theme
	end
  end
  
end
