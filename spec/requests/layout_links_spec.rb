require 'spec_helper'

describe "LayoutLinks" do
  
  it "should have a Home page at'/'" do
    get '/'
    response.should have_selector('title', :content=> "Home")
  end
  
  it "should have a Contact page at'/contact'" do
    get '/contact'
    response.should have_selector('title', :content=> "Contact")
  end
  
  it "should have an About page at'/about'" do
    get '/about'
    response.should have_selector('title', :content=> "About")
  end
  
  it "should have a Profile page at'/profile'" do
    get '/profile'
    response.should have_selector('title', :content=> "Profile")
  end
  
  it "should have a Log Your Run page at'/log_run'" do
    get '/log_run'
    response.should have_selector('title', :content=> "Log")
  end
  
  it "should have a Login page at'/login'" do
    get '/login'
    response.should have_selector('title', :content=> "Login")
  end
  
  it "should have a Sign Up page at'/signup'" do
    get '/signup'
    response.should have_selector('title', :content=> "Sign Up")
  end
  
  it "should have a Help page at'/help'" do
    get '/help'
    response.should have_selector('title', :content=> "Help")
  end
  
  it "should have the right links on the layout" do
    visit root_path
    click_link "Sign up now!"
    response.should have_selector('title', :content => "Sign Up")
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Log Your Run"
    response.should have_selector('title', :content => "Log")
    click_link "Log In"
    response.should have_selector('title', :content => "Login")
    click_link "Profile"
    response.should have_selector('title', :content => "Profile")
  end
  
end
