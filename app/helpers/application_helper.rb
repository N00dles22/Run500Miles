#require 'yaml'

module ApplicationHelper
  
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
  
end
