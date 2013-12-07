class ActivitiesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,    only: [:index, :get_activities]
  before_filter :admin_user,      only: [:new, :create, :search, :move, :resize, :edit, :update, :destroy]
  
  def new
    @user = User.find((params[:user_id]))
    @activity = Activity.new
  end
  
  def search
    @name = params[:name]
	@project = params[:project]
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
	
	activities = Activity.where({})
	
	if !@name.blank?
	  @name = @name.gsub(/\s+/, " ").strip.titleize
	  users = User.where("name = ?", @name).all
	  user_ids = Array.new
	  users.each do |u|
	    user_ids.push(u.id)
	  end
	  activities = activities.where(:user_id=> user_ids)
	end
	
    if !@start_date.blank?
	  activities = activities.where("date(start_time) >= ?", @start_date)
	end
	
	if !@end_date.blank?
	  activities = activities.where("date(start_time) <= ?", @end_date)
	end
	
	if !@project.blank?
	  activities = activities.where("project = ?", @project)
	end
		
	@activities = activities.order(:start_time).paginate(page: params[:page])
  end
  
  def create
    @user = User.find((params[:user_id]))
    if params[:activity][:period] == "No repeat"
	  @activity = Activity.new(params[:activity].except(:period, :frequency, :month_num))	  
    else
      @activity_series = ActivitySeries.new(params[:activity].except(:user_id, :hour_num, :project, :remark))
	  @activity_series.user_id = params[:activity][:user_id]
	  @activity_series.hour_num = params[:activity][:hour_num]
	  @activity_series.project = params[:activity][:project]
	  @activity_series.remark = params[:activity][:remark]
    end
  end
  
  def index   
  end
  
  
  def get_activities
	if @user.admin?
      @activities = Activity.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and start_time < '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
	  #@activities = Activity.all
	  events = [] 
      @activities.each do |activity|
	    end_time = activity.start_time + activity.hour_num.hour
	    user = User.find (activity.user_id)
		status = Status.find (user.status)
		desc_time = 'Time: ' + activity.start_time.to_date.to_s + ' ' + activity.start_time.strftime("%I:%M%p").to_s + '-' + end_time.strftime("%I:%M%p").to_s
		desc_project = 'Project: ' + Project.find(activity.project).name
		if activity.remark.blank?
		  desc_remark = ''
		else
		  desc_remark = 'Remark: ' + activity.remark
		end
        events << {:id => activity.id, :title => user.name + ' - ' + status.name, :desc_time => desc_time, :desc_project => desc_project, :desc_remark => desc_remark, :start => "#{activity.start_time.iso8601}", :end => "#{end_time.iso8601}", :allDay => false, :recurring => (activity.activity_series_id)? true: false}
      end
	else
	  @activities = @user.activities.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and start_time < '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
	  #@activities = Activity.all
	  events = [] 
      @activities.each do |activity|
	    end_time = activity.start_time + activity.hour_num.hour
		user = User.find (activity.user_id)
		status = Status.find (user.status)
		desc_time = 'Time: ' + activity.start_time.to_date.to_s + ' ' + activity.start_time.strftime("%I:%M%p").to_s + '-' + end_time.strftime("%I:%M%p").to_s
		desc_project = 'Volunteer: ' + user.name  + ' - ' + status.name
		if activity.remark.blank?
		  desc_remark = ''
		else
		  desc_remark = 'Remark: ' + activity.remark
		end
	    project = Project.find (activity.project)
        events << {:id => activity.id, :title => project.name, :desc_time => desc_time, :desc_project => desc_project, :desc_remark => desc_remark, :start => "#{activity.start_time.iso8601}", :end => "#{end_time.iso8601}", :allDay => false, :recurring => (activity.activity_series_id)? true: false}
      end
	end
	  
    render :text => events.to_json
  end
  
  
  
  def move
    @activity = Activity.find_by_id params[:id]
    if @activity
      @activity.start_time = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@activity.start_time))
      @activity.save
    end
  end
  
  
  def resize
    @activity = Activity.find_by_id params[:id]
    if @activity
      @activity.hour_num = (params[:minute_delta].to_i) / 60.0 + (params[:day_delta].to_i) * 24 + @activity.hour_num
      @activity.save
    end    
  end
  
  def edit
    @activity = Activity.find_by_id(params[:id])
  end
  
  def update
    @activity = Activity.find_by_id(params[:id])
    if params[:commit] == "Update All Occurrence"
      @activities = @activity.activity_series.activities
      @activity.update_activities(@activities, params[:activity])
    elsif params[:commit] == "Update All Following Occurrence"
      @activities = @activity.activity_series.activities.find(:all, :conditions => ["start_time >= '#{@activity.start_time.to_formatted_s(:db)}' "])
      @activity.update_activities(@activities, params[:activity])
    else
	  @activity.update_attributes(params[:activity])
    end    
  end  
  
  def destroy
    @activity = Activity.find_by_id(params[:id])
    if params[:delete_all] == 'true'
      @activity.activity_series.destroy
    elsif params[:delete_all] == 'future'
      @activities = @activity.activity_series.activities.find(:all, :conditions => ["start_time >= '#{@activity.start_time.to_formatted_s(:db)}' "])
      @activity.activity_series.activities.delete(@activities)
    else
      @activity.destroy
    end    
  end
  
  private
    # correct user or admin
    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)|| current_user.admin?
    end
  
end
