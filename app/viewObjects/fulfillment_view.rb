module FulfillmentView
  def editable
    {
        message: message
    }
  end

  def public
    {
        id: id,
        requestId: request_id,
        responseId: response_id,
        posted: created_at,
        postedBy: user_id,
        message: message
    }
  end

  def list
    {
        id: id,
        requestId: request_id,
        response: response_id,
        posted: created_at,
        postedBy: user_id,
        message: message
    }
  end

  def with_user_detail
    {
        id: id,
        requestId: request.id,
        responseId: response.id,
        posted: created_at,
        postedBy: {
            userId: user.id,
            userName: user.username
        },
        message: message
    }
  end

  def recursive
    {
        id: id,
        request: request,
        response: response,
        posted: created_at,
        postedBy: {
            userId: user.id,
            userName: user.username
        },
        message: message
    }
  end
end