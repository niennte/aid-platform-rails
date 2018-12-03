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
        status: status,
        fulfillment: fulfillment ?
            fulfillment.extend(FulfillmentView).list :
            nil
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
        request: request.extend(RequestView).public,
        posted: created_at,
        message: message,
        status: status,
        fulfillment: fulfillment ?
            fulfillment.extend(FulfillmentView).list :
            nil
    }
  end

  def recursive
    {
        id: id,
        message: message,
        status: status,
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