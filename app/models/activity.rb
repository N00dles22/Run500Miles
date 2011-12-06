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

class Activity < ActiveRecord::Base
  attr_accessible :comment, :activity_date, :distance,
                  :hours, :minutes
                  
  belongs_to :user
  
  validates :user_id,       :presence => true
  validates :activity_date, :presence => true
  validates :distance,      :presence => true,
                            :numericality => { :greater_than => 0.0 }
  validates :hours,         :presence => true,
                            :numericality => { :greater_than_or_equal_to => 0}
  validates :minutes,       :presence => true,
                            :numericality => { :greater_than_or_equal_to => 0}
  validates :comment,       :length => { :maximum => 140 }
  validate :validate_non_zero_time
  validate :validate_activity_date
  
  default_scope :order => "activities.created_at DESC"
  
private
  def validate_non_zero_time
    if (self.hours == 0 && self.minutes == 0)
      errors.add(:base, "An activity time of 0 is not allowed.")
    end
  end
  
  def validate_activity_date
    if (!self.activity_date.nil? && self.activity_date > Date.today)
      errors.add(:activity_date, "cannot be in the future")
    end
  end
end
