class Activity < ActiveRecord::Base
  attr_accessible :user_id, :start_time, :hour_num, :project, :remark
  attr_accessor :period, :frequency, :month_num
  
  validates_presence_of :user_id, :start_time, :project, :hour_num
  
  belongs_to :user
  belongs_to :activity_series
    
  REPEATS = [
              "No repeat",
              "Weekly"         ,
              "Monthly"
  ]
  
  def update_activities(activities, activity)
    activities.each do |e|
      begin 
        st = e.start_time
        e.attributes = activity
        if activity_series.period.downcase == 'monthly'
		  dd = Date.parse("#{e.start_time.day}-#{st.month}-#{st.year}")
          nst = Time.zone.parse("#{e.start_time.hour}:#{e.start_time.min}:#{e.start_time.sec}, #{e.start_time.day}-#{st.month}-#{st.year}")  
        else
		  dd = Date.parse("#{st.day}-#{st.month}-#{st.year}")
          nst = Time.zone.parse("#{e.start_time.hour}:#{e.start_time.min}:#{e.start_time.sec}, #{st.day}-#{st.month}-#{st.year}")
        end
		#puts "#{nst}           :::::::::          "
        
      rescue
        dd = nil
      end
      if dd
        e.start_time = nst
        e.save
	  else
	    e.destroy
      end
    end
    

  end
end
