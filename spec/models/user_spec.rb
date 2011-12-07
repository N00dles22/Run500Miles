require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  before(:each) do
    @attr = {
      :fname => "Nick",
      :lname => "Gallegos",
      :email => "nick.gallegost@example.com",
      :password => "foobar",
      :password_confirmation => "foobar",
      :secret_word => "angusbeef"
      }
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
  
  it "should require a secret word" do
    no_sw_user = User.new(@attr.merge(:secret_word => ""))
    no_sw_user.should_not be_valid
  end
  
  it "should accept the secret word" do
    sw_user = User.new(@attr.merge(:secret_word => "angusbeef"))
    sw_user.should be_valid
  end
  
  it "should reject incorrect secret words" do
    secret_words = %w[testword notangusbeef wrongsw]
    secret_words.each do |sw|
      invalid_sw_user = User.new(@attr.merge(:secret_word => sw))
      invalid_sw_user.should_not be_valid
    end
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
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
    
  end
  
  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
  describe "activity associations" do

    before(:each) do
      @user = User.create(@attr)
      @ac1 = Factory(:activity, :user => @user, :created_at => 1.day.ago)
      @ac2 = Factory(:activity, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have an activities attribute" do
      @user.should respond_to(:activities)
    end
    
    it "should have the right activities in the right order" do
      @user.activities.should == [@ac2, @ac1]
    end
    
    it "should destroy associated activities" do
      @user.destroy
      [@ac1, @ac2].each do |activity|
        Activity.find_by_id(activity.id).should be_nil
      end
    end
    
    it "should have a feed" do
      @user.should respond_to(:feed)
    end
    
    it "should include the user's activities" do
      @user.feed.include?(@ac1).should be_true
      @user.feed.include?(@ac2).should be_true
    end
    
    it "should not include a different user's activities" do
      ac3 = Factory(:activity,
                    :user => Factory(:user, :email => Factory.next(:email)))
      @user.feed.include?(ac3).should be_false
    end
  end
  
end


# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  fname              :string(255)
#  lname              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  user_type          :string(255)     default("2")
#

