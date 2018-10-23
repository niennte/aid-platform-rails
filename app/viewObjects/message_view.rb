module MessageView

  def editable
    {
        subject: subject,
        body: body
    }
  end

  def public
    {
        id: id,
        senderId: user_id,
        subject: subject,
        body: body,
        sent: created_at
    }
  end

  def recursive
    {
        id: id,
        sender: {
            senderId: user.id,
            senderName: user.username
        },
        subject: subject,
        body: body,
        sent: created_at
    }
  end
end