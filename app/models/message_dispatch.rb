class MessageDispatch < ApplicationRecord
  include Wisper::Publisher
  subscribe(AsyncController.new, async: true)

  # only call callback if the is_read attribute has actually been updated
  after_commit :publish_inbox_update,
     if: proc { |record|
       record.previous_changes.key?(:is_read) &&
           record.previous_changes[:is_read].first != record.previous_changes[:is_read].last
     }

  validates :user, presence: true
  validates :message, presence: true
  validates :is_read, inclusion: { in: [ true, false ], message: 'should be true or false, or evaluate to such.' }

  belongs_to :user
  belongs_to :message

  def self.all_for_user(user: required)
    # created_at represents the time the message is received
    forUser(user.id).order('created_at desc')
  end

  def self.with_message
    select("#{table_name}.*,
messages.created_at as sent,
messages.user_id as sender_id,
users.username as sender_username,
messages.subject as message_subject,
messages.body as message_body")
        .joins(:message)
        .joins('INNER JOIN users ON messages.user_id = users.id')
  end

  private

  def publish_inbox_update
    if is_read
      publish(:inbox_unread_remove, user_id)
    else
      publish(:inbox_unread_add, user_id)
    end
  end
end
