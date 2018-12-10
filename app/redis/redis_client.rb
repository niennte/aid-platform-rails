class RedisClient

  def init_store
    $redis.flushall
    $redis.set 'members', -1
    $redis.incr 'members'
    $redis.set 'fulfilled', -1
    $redis.incr 'fulfilled'
    $redis.set 'response', -1
    $redis.incr 'response'
  end

  def push_request_activate(request)
    $redis.geoadd(
        'requests:locations',
        request[:location][:lng],
        request[:location][:lat],
        request[:name],
    )

    # active request quick lookup
    $redis.hmset(
        "requests:data:request:#{request[:name]}",
        'type',
        request[:category],
        'userId',
        request[:user][:userId],
        'userName',
        request[:user][:userName],
        'lat',
        request[:location][:lat],
        'lng',
        request[:location][:lng],
        'title',
        request[:title],
        'description',
        request[:description],
        'address',
        request[:fullAddress],
        'city',
        request[:city],
        'postalCode',
        request[:postalCode],
        'country',
        request[:country]
    )
  end

  # remove from the "redis geo list"
  def push_request_deactivate(request)
    $redis.zrem(
      'requests:locations',
      request[:name]
    )
  end

  # used to determine by frontend if a pending request can be republished
  # if not in the suspended list, it CAN be republished
  # if suspended list is ignored, rules will still be enforced by the API
  # but this will take the unload off the API
  def push_request_suspend(request_id, expiry)
    sleep 1
    puts '******* request_push_suspended'
    sleep 3
    puts "******* pushed_suspended #{request_id}, #{expiry}"
  end

  def push_request_unsuspend(request_id)
    sleep 1
    puts '******* request_push_unsuspend'
    sleep 3
    puts "******* pushed_unsuspend #{request_id}"
  end

  def push_user_message_incr(user_id)
    $redis.incr("messages:user:#{user_id}")
  end

  def push_user_message_decr(user_id)
    $redis.decr("messages:user:#{user_id}")
  end

  def push_user_incr
    # increment redis users counter
    $redis.incr('members')
  end

  def push_user_decr
    # decrement redis users counter
    $redis.decr('members')
  end

  def push_response_incr
    # increment redis response counter
    $redis.incr('response')
  end

  def push_response_decr
    # decrement redis response counter
    $redis.decr('response')
  end

  def push_fulfillment_incr
    # increment redis fulfillments counter
    $redis.incr('fulfilled')
  end

  def push_fulfillment_decr
    # decrement redis fulfillments counter
    $redis.decr('fulfilled')
  end

  # TODO add a sync resource / sync all job triggerable from the API
  # eg POST /sync/[resource] #sync
  # GET /sync/[resource] # dry run
  # - in this case, no reason to execute asynchronously,
  # so this Redis Client should definitely be separate

end