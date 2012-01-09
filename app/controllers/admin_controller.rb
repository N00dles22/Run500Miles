class AdminController < ApplicationController
  before_filter :admin_user, :only => [:edit_quote, :update_quote]
  before_filter :dev_user, :only => [:site_config, :new_config, :create_config, :config_index, :update_config,
                                     :destroy_config ]
  
  def new_config
	@config = Configuration.new
  end
  
  def create_config
    @config = Configuration.new(params[:configuration])
	
	if @config.save
	  flash[:success] = "Configuration successfully created!"
	  redirect_to config_index_path
	else
	  render 'new_config'
	end
  end
  
  def config_index
    @configs = Configuration.find(:all)
  end

  def site_config
    #@config_list = Configuration.all
	@config = Configuration.find(params[:id])
	#if (!params[:id].nil?)
	#  index = @config_list.index{ |c| c.id == params[:id] }
	#  @config = @config_list[index.nil? ? 0 : index]
	#end
  end
  
  def update_config
    @config = Configuration.find(params[:id])
    if (@config.update_attributes(params[:configuration]))
	  flash[:success] = "Config Updated"
	else
	  render 'site_config'
	end
    redirect_to '/config_index'
  end
  
  def destroy_config
    Configuration.find(params[:id]).destroy
	flash[:success] = "Configuration destroyed"
	redirect_to config_index_path
  end
    
  def update_quote
    if (!params[:qotw][:quote].empty? && !params[:qotw][:source].empty?)
	  q_content = Configuration.find_by_key('quote-content')
	  q_source = Configuration.find_by_key('quote-source')
	  q_content.value = params[:qotw][:quote]
	  q_source.value = params[:qotw][:source]
      #APP_CONFIG.store('quote-content', params[:qotw][:quote])
	  #APP_CONFIG.store('quote-source', params[:qotw][:source])
	  
	  # writes to the config file after storing new values
	  #File.open("#{RAILS_ROOT}/config/config.yml", "w") { |f| YAML.dump(APP_CONFIG, f) }
	  if (q_content.save && q_source.save)
	    flash[:success] = "Quote Updated."
	    redirect_to root_path
	  else
	    render 'edit_quote'
	  end
	else
	  flash[:error] = "You must provide both a quote and a source"
	  render 'edit_quote'
	end
  end
  
  def edit_quote
    
  end

  private
    def dev_user
	  redirect_to(root_path) unless !current_user.nil? && current_user.email == "nicholas.gallegos@gmail.com"
	end
    def admin_user
      redirect_to(root_path) unless !current_user.nil? && current_user.admin?
    end
end
