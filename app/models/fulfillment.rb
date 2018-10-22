class Fulfillment < ApplicationRecord
  belongs_to :response
  belongs_to :user

  validates :response, presence: true
  validates :user, presence: true
end
