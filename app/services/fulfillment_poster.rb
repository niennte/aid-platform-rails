# Transaction wrapper to post a request fulfillment
class FulfillmentPoster
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: Rails.env.production?)

  attr_accessor :poster_id, :response, :message, :errors

  def initialize(params = {})
    @response = params[:response]
    @message = params[:message]
    @errors = {}
  end

  def save
    # Save the Fulfillment, update Request and Response status in a transaction
    ActiveRecord::Base.transaction do
      # create Fulfillment record
      @fulfillment = Fulfillment.new({
          response_id: @response.id,
          request_id: @response.request_id,
          message: @message,
          user: @poster_id
        })
      if @fulfillment.save
        @request = Request.find(@fulfillment.request_id)
        # update Request status
        unless @request.closed!
          @errors = @request.errors.to_h
        end
        # update Response status
        @response = Response.find(@fulfillment.response_id)
        unless @response.delivered!
          @errors.merge(@response.errors.to_h)
        end
      else
        @errors = @fulfillment.errors.to_h
      end
    end
    success = @errors.length == 0
    if success
      publish :fulfillment_create
      publish(:fulfillment_notify, async)
    end
    success
  end

  def public
    @fulfillment.extend(FulfillmentView).public
  end

  def async
    public.deep_dup
  end

  def recursive
    @fulfillment.extend(FulfillmentView).recursive
  end

  def editable
    @fulfillment.extend(FulfillmentView).editable
  end
end
