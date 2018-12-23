module AccountView
  def editable
    {
      first_name: first_name,
      last_name: last_name,
      pic: pic
    }
  end

  def async
    public.deep_dup
  end

  def public
    {
      user_id: user_id,
      first_name: first_name,
      last_name: last_name,
      pic_url: pic.url
    }
  end
end