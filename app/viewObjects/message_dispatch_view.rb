module MessageDispatchView

  def editable
    {
      isRead: is_read
    }
  end

  def public
    {
      id: id,
      to: user_id,
      isRead: is_read,
      readAt: is_read ? updated_at : nil,
      message: message_id,
      received: created_at
    }
  end

  def async
    public.deep_dup
  end

  def list
    {
        id: id,
        from: {
            userId: sender_id,
            userName: sender_username
        },
        to: { # including username here would cause N+1 or require an extra join
            userId: user_id
        },
        sent: sent,
        received: created_at,
        isRead: is_read,
        readAt: is_read ? updated_at : nil,
        subject: message_subject
    }
  end

  def recursive
    {
        id: id,
        to: {
            userId: user.id,
            userName: user.username
        },
        isRead: is_read,
        readAt: is_read ? updated_at : nil,
        received: created_at,
        message:
            {
                id: message_id,
                sent: sent,
                from: {
                    userId: sender_id,
                    userName: sender_username
                },
                subject: message_subject,
                body: message_body
            }
    }
  end
end

