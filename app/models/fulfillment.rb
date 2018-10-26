class Fulfillment < ApplicationRecord
  belongs_to :response
  belongs_to :request
  belongs_to :user

  validates :response, presence: true, uniqueness: true
  validates :request, presence: true, uniqueness: true
  validates :user, presence: true
end
