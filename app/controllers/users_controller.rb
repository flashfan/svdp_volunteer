require 'nokogiri'
class UsersController < ApplicationController

  before_filter :signed_in_user,  only: [:index, :show, :edit, :update, :destroy, :change_status, :change_preference]
  before_filter :signed_out_user, only: :new
  before_filter :correct_user,    only: [:show, :edit, :update, :change_preference]
  before_filter :admin_user,      only: [:index, :destroy, :change_status]
   
  def index
    doc= Nokogiri::XML(File.read('public/xml/usercatalog.xml'))
	doc.css('user').each do |node|
      children = node.children
      User.create(
        :name => children.css('name').inner_text,
        :email => children.css('email').inner_text,
        :phone => children.css('phone').inner_text,
		:password => children.css('password').inner_text,
		:password_confirmation => children.css('password').inner_text,
		:status => children.css('status').inner_text.to_i)
    end 

  
    @name = params[:name]
	@email = params[:email]
	@phone = params[:phone]
	@status = params[:status]
	
	users = User.where("admin = ?", false)
	if !@name.blank?
	  @name = @name.gsub(/\s+/, " ").strip.titleize
	  users = users.where("name = ?", @name)
	end

	if !@email.blank?
	  users = users.where("email = ?", @email)
	end

	if !@phone.blank?
	  users = users.where("phone = ?", @phone)
	end
	
    if !@status.blank?
	  users = users.where("status = ?", @status)
	end

  
   
    @new_users = users.where("status = ?", 1)
	@existing_users = users.where("status > ?", 1).paginate(page: params[:page])
	
	@status_array = Status.all.map { |p| [p.name, p.id] }
	@status_array2 = Status.all.map { |p| [p.name, p.id] }
	@status_array2 = @status_array2.unshift(['----', nil])
  end
  
  def change_status
    user = User.find (params[:user_id])
	user.update_attribute(:status, params[:status])
	redirect_to users_path
  end
  
  def change_preference
    current_id = current_user.id
	@user.update_attribute(:preference_project, params[:project])
	@user.update_attribute(:preference_type, params[:type])
	@user.update_attribute(:preference_period, params[:period])	
	sign_in User.find(current_id)
	redirect_to @user
  end
  
  
  def show
    if @user.admin?
	  redirect_to user_activities_path(current_user)	
	end
	@group_applications = @user.group_applications.paginate(page: params[:page])
	@individual_application = @user.individual_application
  end

  def new
	@user = User.new
  end
  
  def create
	@user = User.new(params[:user])
    if @user.save	  
      sign_in @user
	  msg = ["Welcome to the our volunteer system!", 
	         "Our Volunteer Recruiter will contact you soon to set up an orientation appointment.",
			 "Before that, you can update your volunteer preference and fill out the application form."]
      
      flash[:success] = msg.join("<br/>").html_safe
	  redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    current_id = current_user.id
	if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in User.find(current_id)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
  
  private
    # correct user or admin
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)|| current_user.admin?
    end

end
