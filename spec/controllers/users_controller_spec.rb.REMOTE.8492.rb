require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.fname)
    end
    
    it "should include the users's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.fname)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

  describe "GET 'signup'" do
    it "should be successful" do
      get 'signup'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'signup'
      response.should have_selector("title", :content=> "Sign Up")
    end
    
    it "should have a first name field" do
      get 'signup'
      response.should have_selector("input[name='user[fname]'][type='text']")
    end
    
    it "should have a last name field" do
      get 'signup'
      response.should have_selector("input[name='user[lname]'][type='text']")
    end
    
    it "should have an email field" do
      get 'signup'
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    
    it "should have a password field" do
      get 'signup'
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    
    it "should have a password confirmation field" do
      get 'signup'
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
    
    it "should have a first secret word field" do
      get 'signup'
      response.should have_selector("input[name='user[secret_word]'][type='password']")
    end
    
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      before(:each) do
        @attr = { :fname => "", :lname => "", :password => "",
          :password_confirmation => "", :secret_word => ""}
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign Up")
      end
      
      it "should render the 'signup' page" do
        post :create, :user => @attr
        response.should render_template('signup')
      end
      
    end
    
    describe "success" do
      before(:each) do
        @attr = {:fname => "New", :lname => "User",
          :email => "user@example.com",
          :password => "foobar", :password_confirmation => "foobar",
          :secret_word => "angusbeef"}
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

end
