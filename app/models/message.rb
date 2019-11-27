class Message < ApplicationRecord
  belongs_to :ride
  belongs_to :created_by, class_name: "User"

  validates :content, presence: true, allow_blank: false
end
