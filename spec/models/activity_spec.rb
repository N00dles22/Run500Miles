# == Schema Information
#
# Table name: activities
#
#  id            :integer         not null, primary key
#  comment       :string(255)
#  user_id       :integer
#  activity_date :date
#  distance      :float
#  hours         :integer
#  minutes       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Activity do
  pending "add some examples to (or delete) #{__FILE__}"
end
