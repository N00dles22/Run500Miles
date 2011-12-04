namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:fname => "Nick",
                 :lname => "Gallegos",
                 :email => "nicholas.gallegos@gmail.com",
                 :password => "dagman19",
                 :password_confirmation => "dagman19",
                 :secret_word => "angusbeef")
    admin.toggle!(:admin)             
    #99.times do |n|
    #  fname  = Faker::Name.first_name
    #  lname = Faker::Name.last_name
    #  email = "example-#{n+1}@railstutorial.org"
    #  password  = "password"
    #  User.create!(:fname => fname,
    #               :lname => lname,
    #               :email => email,
    #               :password => password,
    #               :password_confirmation => password,
    #               :secret_word => "angusbeef")
    #end
  end
end