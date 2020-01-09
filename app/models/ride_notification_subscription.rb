class RideNotificationSubscription < ApplicationRecord
  belongs_to :ride
  belongs_to :user

  enum app: [:passenger, :driver]
end
