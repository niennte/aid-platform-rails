module RequestWithResponsesView
  def location
    {
      lat: lat,
      lng: lng
    }
  end

  def name
    "#{id}:#{category}"
  end

  def editable
    {
      title: title,
      description: description,
      address: address,
      category: category
    }
  end

  def public
    {
      id: id,
      userId: user_id,
      name: name,
      title: title,
      description: description,
      address: full_address,
      zip: postal_code,
      location: location,
      created: created_at,
      updated: updated_at,
      type: category,
      status: status,
      numResponses: num_responses
    }
  end

  def list
    {
      id: id,
      user: {
        userId: user_id,
        userName: user_name
      },
      name: name,
      title: title,
      description: description,
      fullAddress: full_address,
      zip: postal_code,
      location: location,
      created: created_at,
      updated: updated_at,
      type: category,
      status: status,
      numResponses: num_responses,
      isFulfilled: is_fulfilled ? true : false
    }
  end

  def summary
    {
        id: id,
        user: {
          userId: user.id,
          userName: user.username
        },
        name: name,
        title: title,
        description: description,
        fullAddress: full_address,
        zip: postal_code,
        location: location,
        created: created_at,
        updated: updated_at,
        type: category,
        status: status,
        numResponses: responses.length,
        isFulfilled: fulfillment ? true : false,
        fulfillmentPostedBy: fulfillment_posted_by
    }
  end

  def recursive
    {
      id: id,
      user: {
        userId: user.id,
        userName: user.username
      },
      name: name,
      title: title,
      description: description,
      fullAddress: full_address,
      zip: postal_code,
      location: location,
      created: created_at,
      updated: updated_at,
      type: category,
      status: status,
      responses: responses,
      fulfillment: fulfillment,
      fulfillmentPostedBy: fulfillment_posted_by
    }
  end

  def fulfillment_posted_by
    if fulfillment.nil?
      return nil
    end
    is_response = responses.find do |response|
      fulfillment.response_id == response.id && fulfillment.user_id == response.user_id
    end
    unless is_response.nil?
      return 'volunteer'
    end
    if fulfillment.user_id == user_id
      return 'poster'
    end
    nil
  end
end