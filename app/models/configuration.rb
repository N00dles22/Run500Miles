class Configuration < ActiveRecord::Base
  attr_accessible :key, :value
  
  validates :key, :presence => true
  validates :value, :presence => true
end
