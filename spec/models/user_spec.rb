# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  fname      :string(255)
#  lname      :string(255)
#

require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  before(:each) do
    @attr = { :fname => "First", :lname => "Last", :email => "first.last@test.com"}
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a first name" do
    no_fname_user = User.new(@attr.merge(:fname => ""))
    no_fname_user.should_not be_valid
  end
  
  it "should require a last name" do
   no_lname_user = User.new(@attr.merge(:lname => ""))
   no_lname_user.should_not be_valid
  end
   
  it "should require an email address" do
   no_email_user = User.new(@attr.merge(:email => ""))
   no_email_user.should_not be_valid
  end
  
  it "should reject first names that are too long" do
    long_fname = "a" * 51 #no first name longer than 50
    long_fname_user = User.new(@attr.merge(:fname => long_fname))
    long_fname_user.should_not be_valid
  end
  
  it "should reject last names that are too long" do
    long_lname = "a" * 51 #no first name longer than 50
    long_lname_user = User.new(@attr.merge(:lname => long_lname))
    long_lname_user.should_not be_valid    
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user123@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
end
