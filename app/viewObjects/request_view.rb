module RequestView
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
        userId: user_id,
        title: title,
        description: description,
        address: full_address,
        posted: created_at,
        type: category,
        status: status
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
        status: status
    }
  end
end