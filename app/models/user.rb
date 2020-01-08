class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :seat_assignments, dependent: :destroy
  has_many :rides_taken, through: :seat_assignments, source: :ride

  has_many :rides_driven, class_name: "Ride", foreign_key: :driver_id,
                          dependent: :nullify

  has_many :ride_notification_subscriptions, dependent: :destroy
  has_many :notifying_rides, through: :ride_notification_subscriptions,
                             source: :ride

  has_many :messages_posted, class_name: "Message", dependent: :destroy

  validates_format_of :email, with: /\A.*@grinnell\.edu\z/i,
                              message: 'must be a grinnell.edu email'

  validates           :phone_number, presence: true, if: :notify_sms?
  validates_format_of :phone_number, with: /\A[0-9]{10}\z/, allow_nil: true,
                                     message: 'must be a valid US phone number'

  # Leave this commented until we have moved most/all of the production DB
  # users over to having names
  # validates :name, presence: { message: 'is required' }

  def notify?
    notify_sms? || notify_email?
  end

  def notified_by_ride?(ride)
    notify? && notifying_rides.include?(ride)
  end

  def display_name
    # Display email if name not present
    if name.presence
      return name
    end

    match = email.match(/\A(.*)@/)
    "[#{match.captures[0]}]"
  end

  def formatted_phone_number
    phone_number.match(/(.{3})(.{3})(.{4})/) do |area_code, prefix, suffix|
      "(#{area_code}) #{prefix}-#{suffix}"
    end
  end
end
