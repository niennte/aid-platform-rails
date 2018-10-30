# Listen to API controller events,
# and process asynchronously
# eg, apply data caching
# policy updates to entity not part of the API call,
# or send notifications
class JobDispatcher

  def initialize
    @redis_client = RedisClient.new
  end

  # update Redis data cache

  def request_create(request)
    puts "$$$$$$$ request_create #{request[:id]}"
    push_request_activate(request)
  end

  def request_update(request)
    puts "$$$$$$$ request_update #{request[:id]}"
    if request[:status] == "active"
      push_request_activate(request)
    else
      push_request_deactivate(request)
    end
  end

  def request_destroy(request)
    puts '$$$$$$$ request_destroy'
    push_request_deactivate(request)
  end

  def user_create
    # increment redis users counter
    push_user_incr
  end

  def user_destroy
    # decrement redis users counter
    push_user_decr
  end

  # per user message counter of unread messages
  def inbox_unread_add(user_id)
    push_user_message_incr(user_id)
  end

  def inbox_unread_remove(user_id)
    push_user_message_decr(user_id)
  end

  # fulfilled requests counter
  def fulfillment_create
    # increment redis fulfillments counter
    push_fulfillment_incr
  end

  def fulfillment_destroy
    # decrement redis fulfillments counter
    push_fulfillment_decr
  end


  # Notifiers

  def response_new_notify(response)
    request = Request.find(response[:requestId])
    UserNotificationDispatcher
        .new(request.user_id)
        .report_new_response(request.title)
  end

  def fulfillment_notify(fulfillment)
    poster_id = Request.find(fulfillment[:requestId]).user_id
    volunteer_id = Response.find(fulfillment[:responseId]).user_id
    UserNotificationDispatcher
      .new(poster_id)
      .report_fulfilled(fulfillment[:requestId], fulfillment[:responseId])
    UserNotificationDispatcher
        .new(volunteer_id)
        .report_fulfilled(fulfillment[:requestId], fulfillment[:responseId])
  end


  private

  # Logic pertaining to the Redis cache

  # pushing "activated" requests to the "redis geo list":
  # geo list is a flat snapshot of the current state of the database
  # with geospacial attributes;
  # redis geospacial queries will take a significant
  # chunk of the heavy lifting
  # off the API and Postgre
  def push_request_activate(request)
    # active request geolocation and lookup
    @redis_client.push_request_activate(request)
  end

  # remove from the "redis geo list"
  def push_request_deactivate(request)
    @redis_client.push_request_deactivate(request)
  end

  # per user message counter
  def push_user_message_incr(user_id)
    # increment redis users counter
    @redis_client.push_user_message_incr(user_id)
  end

  def push_user_message_decr(user_id)
    # decrement redis users counter
    @redis_client.push_user_message_decr(user_id)
  end

  # registered user counter
  def push_user_incr
    # increment redis users counter
    @redis_client.push_user_incr
  end

  def push_user_decr
    # decrement redis users counter
    @redis_client.push_user_decr
  end

  def push_fulfillment_incr
    # increment redis fulfilled request counter
    @redis_client.push_fulfillment_incr
  end

  # fulfilled request counter
  def push_fulfillment_decr
    # decrement redis fulfilled requests counter
    @redis_client.push_fulfillment_decr
  end
end