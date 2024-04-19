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

  def confirm!
    update_columns(confirmed_at: Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end

  def unconfirmed?
    !confirmed?
  end



end
