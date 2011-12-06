# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.fname                  "Nick"
  user.lname                  "Gallegos"
  user.email                 "nick.gallegos@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.secret_word "angusbeef"
end

Factory.sequence :fname do |n|
  "First#{n}"
end

Factory.sequence :lname do |n|
  "Last#{n}"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :activity do |activity|
  activity.comment "comment"
  activity.activity_date Date.today
  activity.distance 2.0
  activity.hours 0
  activity.minutes 25
  
  activity.association :user
end
