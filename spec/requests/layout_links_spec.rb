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
  
end
