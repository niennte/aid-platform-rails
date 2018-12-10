module ResponseView

  def editable
    {
        message: message,
    }
  end

  def public
    {
        id: id,
        user_id: user_id,
        requestId: request_id,
        posted: created_at,
        message: message,
        status: status
    }
  end

  # use in async threads
  def async
    public.deep_dup
  end

  def list
    {
        id: id,
        user_id: user_id,
        request: request.extend(RequestView).recursive_with_fulfillment,
        posted: created_at,
        message: message,
        status: status
    }
  end

  def with_user_detail
    {
        id: id,
        message: message,
        status: status,
        posted: created_at,
        user: {
            userId: user.id,
            userName: user.username
        }
    }
  end

  def recursive
    {
        id: id,
        message: message,
        status: status,
        posted: created_at,
        user: {
          userId: user.id,
          userName: user.username
        },
        request: request.extend(RequestView).recursive_with_fulfillment
    }
  end
end