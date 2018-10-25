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
      numResponses: num_responses
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
      responses: responses
    }
  end
end