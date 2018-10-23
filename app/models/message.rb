class Message < ApplicationRecord

  attr_accessor :message_dispatch

  validates :subject, presence: true, length: { maximum: 255, message: 'cannot be longer than 100 characters.' }

  validates :body, presence: true, length: { maximum: 500, message: 'cannot be longer than 500 characters.' }

  validates :user, presence: true

  belongs_to :user
  has_one :message_dispatch

  def self.all_for_user(user: required)
    # created_at represents the time the message is received
    forUser(user.id)
        .order('created_at desc')
  end

  def self.with_dispatch
    select("#{table_name}.*, message_dispatches.created_at as delivered, message_dispatches.user_id as recipient_id, users.username as recipient_username, message_dispatches.is_read as read")
    .joins(:message_dispatch)
    .joins('INNER JOIN users ON message_dispatches.user_id = users.id')
  end

end
