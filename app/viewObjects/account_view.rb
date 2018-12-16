module AccountView
  def editable
    {
      first_name: first_name,
      last_name: last_name,
      pic: pic
    }
  end

  def public
    {
      first_name: first_name,
      last_name: last_name,
      pic_square: pic.url(:square),
      pic_thumb: pic.url(:thumb),
      pic_medium: pic.url(:medium),
      pic_url: pic.url
    }
  end
end