class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

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
  has_many :reservations, dependent: :destroy
  has_many :properties, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end
end
