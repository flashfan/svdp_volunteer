class VolunteerHoursController < ApplicationController
  before_filter :signed_in_user 
  before_filter :correct_user,    only: [:index, :create]
  before_filter :admin_user,      only: :destroy


  def index
    date = params[:date]
    if !date.blank?
	  begin
	    @start_date = Date.new date["start_date(1i)"].to_i, date["start_date(2i)"].to_i, date["start_date(3i)"].to_i	  
	  rescue
	    @start_date = nil
	  end
	  begin
	    @end_date = Date.new date["end_date(1i)"].to_i, date["end_date(2i)"].to_i, date["end_date(3i)"].to_i
	  rescue
	    @end_date = nil
	  end
	end
	
	volunteer_hours = VolunteerHour.where("user_id = ?", @user.id)
	
	if !@start_date.blank?
	  volunteer_hours = volunteer_hours.where("date_worked >= ?", @start_date)
	end
	
	if !@end_date.blank?
	  volunteer_hours = volunteer_hours.where("date_worked <= ?", @end_date)
	end
	
    @volunteer_hours = volunteer_hours.order(:date_worked).all
  end
  
  def create
    @user.volunteer_hours.create(params[:volunteer_hour])
    redirect_to user_volunteer_hours_url(@user)
  end
  
  def destroy
    @user = User.find(params[:user_id])
    @user.volunteer_hours.find(params[:id]).destroy
	flash[:success] = "Volunteer hours destroyed."
    redirect_to user_volunteer_hours_url(@user)
  end
  
  private
  
    def correct_user
	  @user = User.find(params[:user_id])
	  if @user.admin?
	    redirect_to root_url
	  end	  
      if !current_user.admin? && current_user!=@user
        redirect_to root_url
	  end
    end
end
