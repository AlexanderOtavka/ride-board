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
  # Uncomment this if we want to skip email confirmation
  #def confirmation_required?
  #  false
  #end
end
