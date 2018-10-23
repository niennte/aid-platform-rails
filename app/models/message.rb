class Message < ApplicationRecord
  validates :subject, presence: true, length: { maximum: 255, message: 'cannot be longer than 100 characters.' }

  validates :body, presence: true, length: { maximum: 500, message: 'cannot be longer than 500 characters.' }

  validates :user, presence: true

  belongs_to :user
end
