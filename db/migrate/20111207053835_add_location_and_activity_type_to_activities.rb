class AddLocationAndActivityTypeToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :location, :string, :default => ""
    add_column :activities, :activity_type, :string, :default => "3"
  end

  def self.down
    remove_column :activities, :activity_type
    remove_column :activities, :location
  end
end
