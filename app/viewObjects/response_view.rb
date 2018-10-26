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
        fulfillment: fulfillment ?
            fulfillment.extend(FulfillmentView).list :
            nil
    }
  end

  def list
    {
        id: id,
        user_id: user_id,
        request: request.extend(RequestView).list,
        posted: created_at,
        message: message,
        fulfillment: fulfillment ?
            fulfillment.extend(FulfillmentView).list :
            nil
    }
  end

  def recursive
    {
        id: id,
        message: message,
        posted: created_at,
        postedBy: {
            id: user.id,
            userName: user.username
        },
        request: request.extend(RequestView).public,
        fulfillment: fulfillment ?
            fulfillment.extend(FulfillmentView).list :
            nil
    }
  end
end