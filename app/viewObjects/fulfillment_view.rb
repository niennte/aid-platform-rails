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

  def recursive
    {
        id: id,
        requestId: request,
        response: response,
        posted: created_at,
        postedBy: user,
        message: message
    }
  end
end