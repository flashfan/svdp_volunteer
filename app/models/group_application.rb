class GroupApplication < ActiveRecord::Base
  attr_accessible :address, :city, :criminal_history, :emergency_email, :emergency_name, :emergency_phone, :emergency_relationship, :explanation, :group_members, :group_size, :group_name, :relationship, :state, :zip_code
  attr_writer :current_step
  
  belongs_to :user

  validates :user_id, presence: true
  
  default_scope order: 'group_applications.updated_at DESC'
  
  before_save { emergency_email.downcase! }
  before_save { emergency_phone.gsub!(/\D/, '') }

  VALID_ZIP_REGEX = /^\d{5}$/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PHONE_REGEX = /^\d{3}[-\s]{0,1}\d{3}[-\s]{0,1}\d{4}$/
  
  validates :group_name,  presence: true, length: { maximum: 50 }, :if => :group_information?
  validates :address, presence: true, length: { maximum: 50 }, :if => :group_information?
  validates :city, presence: true, length: { maximum: 50 }, :if => :group_information?
  validates :state, presence: true, length: { maximum: 50 }, :if => :group_information?
  validates :zip_code, format: { with: VALID_ZIP_REGEX, message: "must be in ##### format."}, :if => :group_information?
  validates :relationship, presence: true, length: { maximum: 50 }, :if => :group_information?
  
  validates :emergency_name, presence: true, length: { maximum: 50 }, :if => :emergency_contact?
  validates :emergency_relationship, presence: true, length: { maximum: 50 }, :if => :emergency_contact?
  validates :emergency_phone, format: { with: VALID_PHONE_REGEX, message: "numbers must be in ###-###-#### or ########## format."}, :if => :emergency_contact?
  validates :emergency_email, format: { with: VALID_EMAIL_REGEX }, :if => :emergency_contact? 

  validates :explanation, presence: true, :if => :group_history?
  
  validates :group_size, numericality: { greater_than: 0, only_integer: true, message: "must be an integer."}, :if => :group_members?
  
  
  def current_step
    @current_step || steps.first
  end
  
  def steps
    %w[group_information emergency_contact group_history group_members confirmation]
  end
  
  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end
  
  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end
  
  def first_step?
    current_step == steps.first
  end
  
  def last_step?
    current_step == steps.last
  end
  
  def group_information?
    current_step == "group_information" || current_step == "confirmation"
  end
  
  def emergency_contact?
    current_step == "emergency_contact" || current_step == "confirmation"
  end
  
  def group_history?
    (current_step == "group_history" || current_step == "confirmation") && criminal_history
  end
  
  def group_members?
    current_step == "group_members" || current_step == "confirmation"
  end

end
