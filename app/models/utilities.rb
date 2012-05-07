include ActionView::Helpers::TagHelper

class Utilities

  class UI

  def self.progress_bar(progress,options={})  
    width = options[:width] || 500  
    height = options[:height] || 20  
    bg_color=options[:bg_color] || "#DDD"  
    bar_color=options[:bar_color] || get_month_options[:colors][0]
    bar_max=options[:bar_max] || 100   
    text = options[:text]  || ""
    ideal_progress = options[:ideal_progress] || width
    iprog_color = options[:iprog_color] || "black"
    if text  
      height = 20 unless height>=20  
      text_color = options[:text_color] || "white"       
      text_content = content_tag(:span,text,:style=>"margin-right: 3px; color: #{text_color};")  
    end       
	if progress > bar_max
	  progress = bar_max
	end
    bar_style = "width: #{width}px; background: #{bg_color}; border: 1px solid black; height: #{height}px;"  
    progress_style = "text-align: right; float: left; background: #{bar_color}; width: #{progress*width/bar_max}px; height: #{height}px"  
    iprog_style = "float: left; width: #{ideal_progress*width/bar_max}px; height: => #{height}px; border-right: 1px solid #{iprog_color}"
    if (ideal_progress > progress)
      content_tag(:div, 
        content_tag(:div, content_tag(:div,text_content,:style=>progress_style), :style => iprog_style ),
	    :style=>bar_style)
    else
      content_tag(:div, 
        content_tag(:div, content_tag(:div, text_content, :style => iprog_style), :style=>progress_style),
	    :style=>bar_style)
    end	
  end  
  
  def self.get_month_options
    month = Date.today.month
    case month 
	  when 1
	    return {:colors => ['#0000FF', '#009999', '#669999'].shuffle!, :pieSliceTextStyle => {:color => 'white', :fontName => 'Arial Bold', :fontSize => 12} }
	  when 2
	    return {:colors => ['#800000', '#A31947', '#9933FF'].shuffle!, :pieSliceTextStyle => {:color => 'black', :fontName => 'Arial Bold', :fontSize => 12} }
	  when 3
	    return {:colors => ['#006600', '#B8B800', '#33CC33'].shuffle!, :pieSliceTextStyle => {:color => 'black', :fontName => 'Arial Bold', :fontSize => 12} }
	  when 4
	    return {:colors => ['#008F47', '#0099FF', '#FFFF4D'].shuffle!, :pieSliceTextStyle => {:color => 'black', :fontName => 'Arial Bold', :fontSize => 12} }
	  when 5
	    return {:colors => ['#990000', '#0099CC', '#99CC00'].shuffle!, :pieSliceTextStyle => {:color => 'white', :fontName => 'Arial Bold', :fontSize => 12} }
	  when 6
	    return {:colors => ['#f30a25', '#48c82e', '#c9b46b'].shuffle!, :pieSliceTextStyle => {:color => 'white', :fontName => 'Arial Bold', :fontSize => 12} }
	  when 7
	    return {:colors => ['#661598', '#f90000', '#59f33a'].shuffle!, :pieSliceTextStyle => {:color => 'white', :fontName => 'Arial Bold', :fontSize => 12} }
	  #when 8
	  #  return {:colors => ['#800000', '#A31947', '#9933FF'].shuffle!, :pieSliceTextStyle => {:color => 'white', :fontName => 'Arial Bold', :fontSize => 12} }
	  #when 9
	  #  return {:colors => ['#006600', '#B8B800', '#33CC33'].shuffle!, :pieSliceTextStyle => {:color => 'white', :fontName => 'Arial Bold', :fontSize => 12} }
	  #when 10
	  #  return {:colors => ['#0000FF', '#009999', '#66FFFF'].shuffle!, :pieSliceTextStyle => {:color => 'white', :fontName => 'Arial Bold', :fontSize => 12} }
	  #when 11
	  #  return {:colors => ['#800000', '#A31947', '#9933FF'].shuffle!, :pieSliceTextStyle => {:color => 'white', :fontName => 'Arial Bold', :fontSize => 12} }
	  #when 12
	  #  return {:colors => ['#006600', '#B8B800', '#33CC33'].shuffle!, :pieSliceTextStyle => {:color => 'white', :fontName => 'Arial Bold', :fontSize => 12} }
    end
    return {:colors => ['#006600', '#B8B800', '#33CC33'].shuffle!, :pieSliceTextStyle => {:color => 'black', :fontName => 'Arial Bold', :fontSize => 12} }
  end
  end
end