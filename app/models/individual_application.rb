class IndividualApplication < ActiveRecord::Base
  attr_accessible :date_of_birth, :address, :city, :state, :zip_code, :faith,
                  :emergency_name,:emergency_relationship, :emergency_phone, :emergency_email, 
				  :reference1_name, :reference1_relationship, :reference1_phone, :reference1_email,
				  :reference2_name, :reference2_relationship, :reference2_phone, :reference2_email,
				  :criminal_history, :dismiss_history, :explanation
				  
  attr_writer :current_step
  
  belongs_to :user

  validates :user_id, presence: true
  
  default_scope order: 'individual_applications.updated_at DESC'
  
  before_save { emergency_email.downcase! }
  before_save { emergency_phone.gsub!(/\D/, '') }
  before_save { reference1_email.downcase! }
  before_save { reference1_phone.gsub!(/\D/, '') }
  before_save { reference2_email.downcase! }
  before_save { reference2_phone.gsub!(/\D/, '') }

  VALID_ZIP_REGEX = /^\d{5}$/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PHONE_REGEX = /^\d{3}[-\s]{0,1}\d{3}[-\s]{0,1}\d{4}$/
  
  validates :address, presence: true, length: { maximum: 50 }, :if => :applicant_information?
  validates :city, presence: true, length: { maximum: 50 }, :if => :applicant_information?
  validates :state, presence: true, length: { maximum: 50 }, :if => :applicant_information?
  validates :zip_code, format: { with: VALID_ZIP_REGEX, message: "must be in ##### format."}, :if => :applicant_information?
  
  validates :emergency_name, presence: true, length: { maximum: 50 }, :if => :emergency_contact?
  validates :emergency_relationship, presence: true, length: { maximum: 50 }, :if => :emergency_contact?
  validates :emergency_phone, format: { with: VALID_PHONE_REGEX, message: "numbers must be in ###-###-#### or ########## format."}, :if => :emergency_contact?
  validates :emergency_email, format: { with: VALID_EMAIL_REGEX }, :if => :emergency_contact? 

  validates :reference1_name, presence: true, length: { maximum: 50 }, :if => :personal_references?
  validates :reference1_relationship, presence: true, length: { maximum: 50 }, :if => :personal_references?
  validates :reference1_phone, format: { with: VALID_PHONE_REGEX, message: "numbers must be in ###-###-#### or ########## format."}, :if => :personal_references?
  validates :reference1_email, format: { with: VALID_EMAIL_REGEX }, :if => :personal_references? 
  validates :reference2_name, presence: true, length: { maximum: 50 }, :if => :personal_references?
  validates :reference2_relationship, presence: true, length: { maximum: 50 }, :if => :personal_references?
  validates :reference2_phone, format: { with: VALID_PHONE_REGEX, message: "numbers must be in ###-###-#### or ########## format."}, :if => :personal_references?
  validates :reference2_email, format: { with: VALID_EMAIL_REGEX }, :if => :personal_references? 
  
  validates :explanation, presence: true, :if => :personal_history?  
  
  def current_step
    @current_step || steps.first
  end
  
  def steps
    %w[applicant_information emergency_contact personal_references personal_history confirmation]
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
  
  def applicant_information?
    current_step == "applicant_information" || current_step == "confirmation"
  end
  
  def emergency_contact?
    current_step == "emergency_contact" || current_step == "confirmation"
  end
 
  def personal_references?
    current_step == "personal_references" || current_step == "confirmation"
  end
 
  def personal_history?
    (current_step == "personal_history" || current_step == "confirmation") && (criminal_history || dismiss_history)
  end

end
