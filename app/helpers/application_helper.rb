require 'yaml'

module ApplicationHelper
  
  # get the quote of the week
  def qotw
    { :content => APP_CONFIG['quote-content'], :source => APP_CONFIG['quote-source'] }
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
