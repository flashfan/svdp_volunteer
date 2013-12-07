class User < ActiveRecord::Base
  attr_accessible :contact_preference, :email, :name, :password, :password_confirmation, :phone, 
                  :status, :preference_project, :preference_type, :preference_period
				  
  default_scope order: 'users.name ASC'
  
  has_secure_password
  
  has_one :individual_application, dependent: :destroy
  has_many :group_applications, dependent: :destroy
  has_many :volunteer_hours, dependent: :destroy
  has_many :activities, dependent: :destroy
  
  
  before_save { email.downcase! }
  before_save { phone.gsub!(/\D/, '') }
  before_save :formalize_name
  before_create :create_remember_token
  
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  VALID_PHONE_REGEX = /^\d{3}[-\s]{0,1}\d{3}[-\s]{0,1}\d{4}$/
  validates :phone, format: { with: VALID_PHONE_REGEX, message: "numbers must be in xxx-xxx-xxxx or xxxxxxxxxx format."}
			
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  after_validation { self.errors.messages.delete(:password_digest) }
  
  private
    
    def formalize_name
	  formal_name = self.name.gsub(/\s+/, " ").strip.titleize
      self.name = formal_name
    end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
