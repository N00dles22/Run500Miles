# == Schema Information
#
# Table name: users
#
#  id                 :integer         primary key
#  email              :string(255)
#  created_at         :timestamp
#  updated_at         :timestamp
#  fname              :string(255)
#  lname              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  user_type          :string(255)     default("2")
#

class User < ActiveRecord::Base
  attr_accessor :password, :secret_word
  attr_accessible :fname, :lname, :email,
                  :password, :password_confirmation,
                  :secret_word, :user_type
  
  has_many :activities, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #sw_regex = /\Aangusbeef\z/i
  
  validates :fname, :presence   => true,
                    :length     => { :maximum => 50 }
  validates :lname, :presence   => true,
                    :length     => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  # Automatically create the virtual attribute 'password_confirmation'
  validates :password,  :presence     => true,
                        :confirmation => true,
                        :length       => { :within => 6..40 }
                        
  #validates :secret_word, :presence => true,
  #                        :format => { :with => sw_regex },
  #                        :on => :create
                          
  validate_on_create :secret_word_okay
  
  before_save :encrypt_password
  
  # Return true if the user's password matches the submitted password
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  
  def total_miles(timespan)
    case timespan
    when "year"
      total = activities.sum(:distance)
    when "week"
      total = activities.sum(:distance,
                                  :conditions => ['activity_date >= ?',
                                                  (Date.today - Date.today.wday)])
    end
  end
  
  def can_view_user?(other_user)
    if (admin?)
      return true
    elsif (user_type.nil? || other_user.user_type.nil?)
      return false
    else
      self_user_types = user_type.split('|')
      other_user_types = other_user.user_type.split('|')
      for i in 0...other_user_types.length
        if self_user_types.include?(other_user_types[i])
          return true
        end
      end
      return false
    end
  end
  
  def total_time(timespan)
    case timespan
    when "year"
      total_hours = activities.sum(:hours)
      total_minutes = activities.sum(:minutes)
      total = total_hours.to_f + (total_minutes.to_f/60)
    when "week"
      total_hours = activities.sum(:hours,
                                        :conditions => ['activity_date >= ?', (Date.today - Date.today.wday)])
      total_minutes = activities.sum(:minutes,
                                        :conditions => ['activity_date >= ?', (Date.today - Date.today.wday)])
      total = total_hours.to_f + (total_minutes.to_f/60)
    end
  end
  
  def miles_left(timespan)
    total = timespan == "year" ? 500 : 10
    m_left = format("%0.2f", [total - total_miles(timespan), 0].max).to_f
  end
  
  def self.leaders(timespan)
    @users = User.find(:all)
    @conditions = []
    case timespan
    when "week"
      @conditions = ['activity_date >= ?', (Date.today - Date.today.wday)]      
    end
    
    @users.sort! { |u1, u2| u2.activities.sum(:distance, :conditions => @conditions) <=>
                  u1.activities.sum(:distance, :conditions => @conditions)}
  end
  
  def self.authenticate(email, submitted_password)
    #user = find_by_email(email)
    #updated user find is case insensitive, which is what we want!
    user = User.find(:all, :conditions =>
                     ["LOWER(email) = ?", email.downcase])[0]
    (user && user.has_password?(submitted_password)) ? user : nil
    #return nil if user.nil?
    #return user if user.has_password?(submitted_password)
    #Automatically returns nil if passwords don't match
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def feed
    if (user_type.nil?)
      Activity.where("user_id = ?", id)
    else
      @ids = []
      User.all.each do |u|
        if (can_view_user?(u))
          @ids.push(u.id)
        end
      end
      Activity.where("user_id IN (?)", @ids)
    end
  end
  
  private
    def secret_word_okay
	  passing = true
	  if (self.secret_word.nil? || self.secret_word.length == 0)
	    errors.add(:secret_word, "cannot be empty.")
		passing = false;
	  end
	  
	  if (passing && self.secret_word != Configuration.find_by_key('secret-word').value)
	    errors.add(:secret_word, "is not correct")
	  end
	  
	end
  
    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

