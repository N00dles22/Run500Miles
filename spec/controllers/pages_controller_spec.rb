require 'spec_helper'

describe PagesController do
  render_views
  
  before(:each) do
    @base_title = "Run 500 Miles"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                                    :content => @base_title + " | Home")
    end
    
  end

  describe "GET 'profile'" do
    it "should be successful" do
      get 'profile'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'profile'
      response.should have_selector("title",
                                    :content => @base_title + " | Profile")
    end
  end

  describe "GET 'log_run'" do
    it "should be successful" do
      get 'log_run'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'log_run'
      response.should have_selector("title",
                                    :content => @base_title + " | Log Your Run")
    end
  end

  describe "GET 'login'" do
    it "should be successful" do
      get 'login'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'login'
      response.should have_selector("title",
                                    :content => @base_title + " | Login")
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                                    :content => @base_title + " | Contact Info")
    end
  end
  
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                                    :content => @base_title + " | About")
    end
  end

end
