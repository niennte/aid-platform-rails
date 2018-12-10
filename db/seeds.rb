# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# initiate Redis
if $redis.nil?
  uri = URI.parse(ENV['REDISCLOUD_URL'])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

RedisClient.new.init_store

# create system user
system_user = User.find_by username: 'AidPlatform'
if system_user.nil?
  User.create!(
      username: 'AidPlatform',
      email: ENV['GMAIL_USERNAME'],
      password: ENV['DEVISE_JWT_SECRET_KEY'],
      password_confirmation: ENV['DEVISE_JWT_SECRET_KEY']
  )
end

# create a 100 users, with usernames and passwords as user[N]@test.com and password[N]
1.upto(100) do |i|
  User.create(
      username: "user#{i}",
      email: "test#{i}@test.com",
      password: "password#{i}",
      password_confirmation: "password#{i}"
  )
end

# create 50 requests (distribute around GTA)
center_point = { lat: 43.646791, lng: -79.526704 }
1.upto(50) do |i|
  user = User.find(rand(User.first.id..User.last.id))
  address = nil
  request = Request.new(
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph(8),
    address: address,
    category: Request.categories.key(rand(0..1)), # get random item from the category enum
    status: 'active',
    user: user,
  )
  # this will reverse-geocode random set of coordinates
  # ironically, some of them will not validate by geocoder -
  # in which case do it over
  until request.valid? do
    address = Geocoder.search(
      [
        center_point[:lat] + rand(-5.00..5.00),
        center_point[:lng] + rand(-5.00..5.00)
      ]
    ).first.address
    request.address = address
  end
  request.save
end

# create 100 responses, to random requests
1.upto(100) do |i|
  request = Request.where(status: :active).order('id ASC').sample
  user = User.where.not(id: request.user_id).sample

  Response.create!(
    message: Faker::TvShows::DrWho.quote,
    request: request,
    user: user
  )
end

# fulfill 15 requests, as posted by request posters
1.upto(15) do |i|

  request = Request.select("requests.*, count(responses.id) as num_responses").joins("INNER JOIN responses ON requests.id = responses.request_id").where(status: :active).group("requests.id").sample

  response = Response.where(request: request).sample

  fulfillment_poster = FulfillmentPoster.new({
                            response: response,
                            message: Faker::TvShows::DrWho.quote
                        })
  fulfillment_poster.poster_id = request.user
  fulfillment_poster.save
end

# fulfill 15 requests, as posted by volunteers
1.upto(15) do |i|
  request = Request.select("requests.*, count(responses.id) as num_responses").joins("INNER JOIN responses ON requests.id = responses.request_id").where(status: :active).group("requests.id").sample

  response = Response.where(request: request).sample

  fulfillment_poster = FulfillmentPoster.new({
                                                 response: response,
                                                 message: Faker::TvShows::DrWho.quote
                                             })
  fulfillment_poster.poster_id = response.user
  fulfillment_poster.save
end

# Messages and dispatches - do not seed for now
# (there should be system generated, for responses and fulfillments
# as well as pending requests)


