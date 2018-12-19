class RequestActivator
  attr_accessor :request, :errors

  def initialize(request)
    @request = request
    @errors = {}
  end

  def save
    request_status_policy = RequestStatusPolicy.new
    if request_status_policy.can_reactivate? @request.id
      @request.active!
    else
      @errors = request_status_policy.errors
    end
    @errors.length == 0
  end

  def public
    @request.public
  end

  def async
    @request.async
  end

  def recursive
    @request.recursive
  end

  def editable
    {
      request_id: request.id
    }
  end
end