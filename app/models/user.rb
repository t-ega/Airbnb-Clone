class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_secure_password

  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/.freeze


  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :last_name, presence: true
  validates :email,
            format: { with: EMAIL_REGEX, message: "Email format must be in the specified format" },
            uniqueness: { message: "A user with this email already exists" }

end
