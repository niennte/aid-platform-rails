module MessageWithDispatchView
    def editable
      {
          subject: subject,
          body: body
      }
    end

    def public
      {
          to: recipient_username,
          id: id,
          senderId: user_id,
          subject: subject,
          body: body,
          sent: created_at,
          delivered: delivered,
          read: read
      }
    end

    def list
      {
          id: id,
          to: {
              userId: recipient_id,
              userName: recipient_username
          },
          from: { # including username here would cause N+1 or require an extra join
              userId: user_id
          },
          subject: subject,
          sent: created_at,
          delivered: delivered,
          read: read
      }
    end

    def recursive
      {
          id: id,
          recipient: {
              id: recipient_id,
              userName: recipient_username
          },
          sender: {
              id: user.id,
              userName: user.username
          },
          subject: subject,
          body: body,
          sent: created_at,
          delivered: delivered,
          read: read
      }
    end
end