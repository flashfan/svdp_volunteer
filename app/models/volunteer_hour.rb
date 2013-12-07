class VolunteerHour < ActiveRecord::Base
  attr_accessible :date_worked, :hours_worked, :project
  
  belongs_to :user

  validates :user_id, presence: true
  
  default_scope order: 'volunteer_hours.date_worked ASC'
  
end
