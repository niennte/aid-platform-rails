# Request status policy service:
# - to remain active, a request needs to have fewer than 5 responses
# from unique users
# - when the 5th response is received,
# the requests becomes deactivated for 24 hours
class RequestStatusPolicy
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: Rails.env.production?)

  attr_reader :errors

  def initialize
    @errors = {}
  end

  # todo: refactor into should_deactivate? method
  # todo: move logic to job dispatcher
  def apply_to_new_response(request_id)
    request = Request.find(request_id)
    unless request.closed?
      # get the creation dates for the responses from unique volunteers
      sql = "select max(created_at) as response_date from responses where request_id=#{request_id} group by user_id order by response_date desc"
      distinct_responses = ActiveRecord::Base.connection.execute(sql)
      # apply policy:
      if distinct_responses.count >= 5
        # the request can be reactivated in 24 hours after the latest response was created
        reactivation_date = distinct_responses.first['response_date'].to_datetime + 24.hours
        # update request status
        request.pending!
        # publish event to remove request from active requests Redis cache
        publish(:push_request_deactivate, request.id)
        # publish event to add the request to the "suspended" Redis lookup
        publish(:push_request_suspend, reactivation_date)
        # inform the request poster
        UserNotificationDispatcher
          .new(request.user_id)
          .report_deactivation(reactivation_date, request.title)
      end
    end
  end

  def can_reactivate?(request_id)
    request = Request.find(request_id)
    if request.closed?
      @errors = {
        request_status: 'Request can\'t reactivate after it\s been closed.'
      }
      return false
    end
    # get the creation dates for the responses from unique volunteers, ordered by response date
    sql = "select max(created_at) as response_date from responses where request_id=#{request_id} group by user_id order by response_date desc"
    distinct_responses = ActiveRecord::Base.connection.execute(sql)
    # apply policy:
    if distinct_responses.count == 0
      return true
    end
    last_response_date = distinct_responses.first['response_date'].to_datetime
    is_activatable = distinct_responses.count < 5 || DateTime.current > last_response_date + 24.hours
    unless is_activatable
      @errors = {
        latest_response_date: "Request can't reactivate before #{last_response_date + 24.hours}"
      }
    end
    is_activatable
  end
end