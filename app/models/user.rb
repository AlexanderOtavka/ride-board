class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :seat_assignments, dependent: :destroy
  has_many :rides_taken, through: :seat_assignments, source: :ride

  has_many :rides_driven, class_name: "Ride", foreign_key: :driver_id,
                          dependent: :nullify
end
