class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_many :seat_assignments, dependent: :destroy
  has_many :rides_taken, through: :seat_assignments, source: :ride

  has_many :rides_driven, class_name: "Ride", foreign_key: :driver_id,
                          dependent: :nullify

  has_many :messages_posted, class_name: "Message", dependent: :destroy

  validates_format_of :email, with: /\A.*@grinnell\.edu\z/i,
                              message: 'must be a grinnell.edu email'

  validates           :phone_number, presence: true, if: :notify_sms?
  validates_format_of :phone_number, with: /\A[0-9]{10}\z/, allow_nil: true,
                                     message: 'must be a valid US phone number'

  def notify?
    notify_sms? || notify_email?
  end

  def formatted_phone_number
    phone_number.match(/(.{3})(.{3})(.{4})/) do |area_code, prefix, suffix|
      "(#{area_code}) #{prefix}-#{suffix}"
    end
  end

  protected

  def password_match?
    self.errors[:password] << I18n.t('errors.messages.blank') if password.blank?
    self.errors[:password_confirmation] << I18n.t('errors.messages.blank') if password_confirmation.blank?
    self.errors[:password_confirmation] << I18n.translate("errors.messages.confirmation", attribute: "password") if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  # new function to set the password without knowing the current
  # password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end
end
