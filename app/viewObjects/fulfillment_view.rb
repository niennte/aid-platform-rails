module FulfillmentView
  def editable
    {
        message: message
    }
  end

  def public
    {
        id: id,
        responseId: response_id,
        postedBy: user_id,
        message: message
    }
  end

  def list
    {
        id: id,
        response: response_id,
        postedBy: user_id,
        message: message
    }
  end

  def recursive
    {
        id: id,
        response: response,
        postedBy: user,
        message: message
    }
  end
end