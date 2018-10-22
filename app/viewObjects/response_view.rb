module ResponseView

  def editable
    {
        message: message,
    }
  end

  def public
    {
        id: id,
        requestId: request_id,
        message: message,
        created: created_at
    }
  end

  def recursive
    {
        id: id,
        message: message,
        request: {
            title: request.title,
            description: request.description
        },
        created: created_at
    }
  end
end