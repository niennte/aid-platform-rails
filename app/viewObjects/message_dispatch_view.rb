module MessageDispatchView

  def editable
    {
        isRead: is_read
    }
  end

  def public
    {
        isRead: is_read,
        readAt: is_read ? updated_at : nil,
        message: message_id,
        received: created_at
    }
  end

  def recursive
    {
        isRead: is_read,
        readAt: is_read ? updated_at : nil,
        received: created_at,
        message:
          {
              id: message.id,
              sender: {
                  senderId: message.user.id,
                  senderName: message.user.username
              },
              subject: message.subject,
              body: message.body,
              sent: message.created_at
          }
    }
  end
end