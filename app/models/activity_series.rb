class ActivitySeries < ActiveRecord::Base
  attr_accessible :start_time, :month_num, :period, :frequency
  attr_accessor :hour_num, :user_id, :project, :remark
  
  validates_presence_of :frequency, :period, :month_num, :start_time
  
  has_many :activities, :dependent => :destroy
  
  after_create :create_activities_until
  
  
  def create_activities_until
    st = start_time
    hn = hour_num
    p = r_period(period)
    nst = st
	dd = 1
    
    while frequency.send(p).from_now(st) <= start_time + month_num.month
      #puts "#{start_time}           :::::::::         "
	  if dd
        self.activities.create(:user_id => user_id, :remark => remark, :start_time => nst, :hour_num => hn, :project => project)
	  end
      nst = st = frequency.send(p).from_now(st)
      
      if period.downcase == 'monthly'
        begin
		  dd = Date.parse("#{start_time.day}-#{st.month}-#{st.year}")
          nst = Time.zone.parse("#{start_time.hour}:#{start_time.min}:#{start_time.sec}, #{start_time.day}-#{st.month}-#{st.year}")  
        rescue
          dd = nil
        end
      end
    end
  end
  
  def r_period(period)
    case period
      when "Weekly"
      p = 'weeks'
      when "Monthly"
      p = 'months'
    end
    return p
  end
end
