class RequestStatusPolicy
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: true)

  def apply_request_policy(request_id)
    request = Request.find(request_id)
    unless request.closed?
      # get the creation dates for the responses from unique volunteers
      sql = "select max(created_at) as response_date from responses where request_id=#{request_id} group by user_id order by response_date desc"
      distinct_responses = ActiveRecord::Base.connection.execute(sql)
      # apply policy
      if distinct_responses.count >= 5
        # the request can be reactivated in 24 hours after the latest response was created
        reactivation_date = distinct_responses.first['response_date'].to_datetime + 24.hours
        # update request status
        request.pending!
        # publish event to remove request from active requests Redis cache
        publish(:push_request_deactivate, request.id)
        # publish event to add the request to the "suspended" lookup
        publish(:push_request_suspended, reactivation_date)
        # inform the request poster
        system_user = User.find_by username: 'AidPlatform'
        message = MessageDispatcher.new({
          sender_id: system_user.id, # system user
          recipient_id: request.user_id,
          subject: 'Request received 5 responses!',
          body: "
Great, your request '#{request.title}' has received responses from 5 different volunteers. It is no longer public so as to give the volunteers the time to fulfill the request. If your request is not fulfilled by #{reactivation_date}, you can publish it again."
        })
        message.save
      end
    end
  end
end