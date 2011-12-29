class AdminController < ApplicationController
  before_filter :admin_user, :only => [:edit_quote, :update_quote]
  before_filter :dev_user, :only => [:site_config]
  def site_config
  
  end
    
  def update_quote
    if (!params[:qotw][:quote].empty? && !params[:qotw][:source].empty?)
      APP_CONFIG.store('quote-content', params[:qotw][:quote])
	  APP_CONFIG.store('quote-source', params[:qotw][:source])
	  flash[:success] = "Quote Updated."
	  redirect_to root_path
	else
	  flash[:error] = "You must provide both a quote and a source"
	  render 'edit_quote'
	end
  end
  
  def edit_quote
  end

  private
    def dev_user
	  redirect_to(root_path) unless current_user.email == "nicholas.gallegos@gmail.com"
	end
    def admin_user
      redirect_to(root_path) unless !current_user.nil? && current_user.admin?
    end
end
