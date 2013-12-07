class IndividualApplicationsController < ApplicationController
  before_filter :signed_in_user
  before_filter :not_admin_user,    only: [:new, :create]
  before_filter :correct_user,    only: [:show, :edit, :update]
  before_filter :admin_user,      only: :destroy
  
  def show
    
  end
  
  def new
    session[:individual_application_params] ||= {}
    @individual_application = current_user.build_individual_application(session[:individual_application_params])
    @individual_application.current_step = session[:individual_application_step]
  end
  
  def create
    session[:individual_application_params].deep_merge!(params[:individual_application]) if params[:individual_application]
    @individual_application = current_user.build_individual_application(session[:individual_application_params])
    @individual_application.current_step = session[:individual_application_step]
	if params[:back_button]
      @individual_application.previous_step
      session[:individual_application_step] = @individual_application.current_step
    elsif @individual_application.valid?
      if @individual_application.last_step?
        @individual_application.save
      else
        @individual_application.next_step
      end
      session[:individual_application_step] = @individual_application.current_step
    end
    if @individual_application.new_record?
      render "new"
    else
      session[:individual_application_step] = session[:individual_application_params] = nil
      flash[:notice] = "Individual application form saved!"
      redirect_to current_user
    end
  end
  
  def edit
	@individual_application.current_step = "confirmation"
  end
  
  def update
    if @individual_application.update_attributes(params[:individual_application])
      flash[:success] = "Individual application form updated."
      redirect_to @individual_application
    else
      render 'edit'
    end
  end
  
  def destroy
    IndividualApplication.find(params[:id]).destroy
	flash[:success] = "Individual application form destroyed."
    redirect_to root_url
  end
  
  private
  
    def correct_user
	  if current_user.admin?
	    @individual_application = IndividualApplication.find(params[:id])
	  else
        @individual_application = current_user.individual_application
	  end
      redirect_to root_url if @individual_application.nil?
    end
end
