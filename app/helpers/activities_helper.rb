module ActivitiesHelper
  def wrap(content, max_width)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s, max_width) }.join(' ')))
  end
  
  def activity_type_s(a_type)
    case a_type
    when "1"
      "ran"
    when "2"
      "walked"
    when "3"
      "ran/walked"
    end
  end

  private

    def wrap_long_string(text, max_width)
     zero_width_space = "&#8203;"
     regex = /.{1,#{max_width}}/
     (text.length < max_width) ? text : 
                              text.scan(regex).join(zero_width_space)
   end
end
