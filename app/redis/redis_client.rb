class RedisClient

  # TODO: Redis push methods should go into own class
  # pushing to the "redis geo list":
  # geo list is a flat snapshot of the current state of the database
  # with geospacial attributes;
  # redis geospacial queries will take a significant
  # chunk of the heavy lifting
  # off the API and Postgre
  def push_request_activate(request)
    sleep 1
    puts '******* request_activate'
    sleep 3
    puts "******* pushed_activated #{request.id}"
  end

  # remove from the "redis geo list"
  def push_request_deactivate(request)
    sleep 1
    puts '******* pushing_deactivate'
    sleep 3
    puts "******* pushed_deactivated #{request.id}"
  end

  # used to determine by front end if a pending request can be republished
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

  # stub
  def push_user_incr
    # increment redis users counter
    $redis.incr('members')
  end

  # stub
  def push_user_decr
    # decrement redis users counter
    $redis.decr('members')
  end

  # stub
  def push_fulfillment_incr
    # increment redis fulfillments counter
    $redis.incr('fulfilled')
  end

  # stub
  def push_fulfillment_decr
    # decrement redis fulfillments counter
    $redis.decr('fulfilled')
  end

  # TODO add a sync resource / sync all job trigerrable from the API
  # eg POST /sync/[resource] #sync
  # GET /sync/[resource] # dry run
  # - in this case, no reason to execute asynchronously,
  # so this Redis Client should definitely be separate

end