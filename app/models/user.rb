class User < ActiveRecord::Base
  attr_accessor :password, :secret_word
  attr_accessible :fname, :lname, :email,
                  :password, :password_confirmation,
                  :secret_word, :user_type
  
  has_many :activities, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  sw_regex = /\Aangusbeef\z/i
  
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
                        
  validates :secret_word, :presence => true,
                          :format => { :with => sw_regex },
                          :on => :create
                          
  
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
    Activity.where("user_id = ?", id)
  end
  
  private
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

