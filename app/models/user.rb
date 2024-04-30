class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/.freeze


  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, if: :encrypted_password_changed?
  validates :email,
            format: { with: EMAIL_REGEX, message: "Email format not recognized" },
            uniqueness: { message: "A user with this email already exists" }

  # --------------
  # Relationships
  # ---------------
  has_many :tokens, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end
end
