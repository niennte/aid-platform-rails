class MessageDispatch < ApplicationRecord

  validates :user, presence: true
  validates :message, presence: true
  validates :is_read, inclusion: { in: [ true, false ], message: 'should be true or false, or evaluate to such.' }

  belongs_to :user
  belongs_to :message

end
