require 'spec_helper'

describe ActivitiesController do
  render_views
  
  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
  
    describe "failure" do
      
      before(:each) do
        @attr = { :activity_date => nil, :hours => nil, :minutes => nil, :distance => nil }
      end

      it "should not create a activity" do
        lambda do
          post :create, :activity => @attr
        end.should_not change(Activity, :count)
      end

      it "should render the home page" do
        post :create, :activity => @attr
        response.should render_template('pages/home')
      end
    end
  
    describe "success" do
      
      before(:each) do
        @attr = { :activity_date => Date.today, :hours => 0, :minutes => 20, :distance => 2.5 }
      end
      
      it "should create a activity" do
        lambda do
          post :create, :activity => @attr
        end.should change(Activity, :count).by(1)
      end
      
      it "should redirect to the home page" do
        post :create, :activity => @attr
        response.should redirect_to(root_path)
      end
      
      it "should have a flash message" do
        post :create, :activity => @attr
        flash[:success].should =~ /activity logged/i
      end
    end
  end
  
  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @activity = Factory(:activity, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @activity
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @activity = Factory(:activity, :user => @user)
      end

      it "should destroy the micropost" do
        lambda do 
          delete :destroy, :id => @activity
        end.should change(Activity, :count).by(-1)
      end
    end
  end
end
