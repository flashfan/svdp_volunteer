class GroupApplicationsController < ApplicationController
  before_filter :signed_in_user 
  before_filter :not_admin_user,    only: [:new, :create]
  before_filter :correct_user,    only: [:show, :edit, :update]
  before_filter :admin_user,      only: :destroy
  
  def show
  end
  
  def new
    session[:group_application_params] ||= {}
    @group_application = current_user.group_applications.build(session[:group_application_params])
    @group_application.current_step = session[:group_application_step]
  end
  
  def create
    session[:group_application_params].deep_merge!(params[:group_application]) if params[:group_application]
    @group_application = current_user.group_applications.build(session[:group_application_params])
    @group_application.current_step = session[:group_application_step]
	if params[:back_button]
      @group_application.previous_step
      session[:group_application_step] = @group_application.current_step
    elsif @group_application.valid?
      if @group_application.last_step?
        @group_application.save
      else
        @group_application.next_step
      end
      session[:group_application_step] = @group_application.current_step
    end
    if @group_application.new_record?
      render "new"
    else
      session[:group_application_step] = session[:group_application_params] = nil
      flash[:notice] = "Group application form saved!"
	  
      redirect_to current_user
    end
  end
  
  def edit
	@group_application.current_step = "confirmation"
  end
  
  def update
    if @group_application.update_attributes(params[:group_application])
      flash[:success] = "Group application form updated."
      redirect_to @group_application
    else
      render 'edit'
    end
  end
  
  def destroy
    GroupApplication.find(params[:id]).destroy
	flash[:success] = "Group application form destroyed."
    redirect_to root_url
  end
  
  private

    def correct_user
	  if current_user.admin?
	    @group_application = GroupApplication.find(params[:id])
	  else
        @group_application = current_user.group_applications.find_by_id(params[:id])
	  end
      redirect_to root_url if @group_application.nil?
    end
end
