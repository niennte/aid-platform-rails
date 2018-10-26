class FulfillmentsController < ApplicationController
  before_action :require_authorization
  before_action :set_model, only: [:show, :update, :destroy]
  before_action :require_ownership, only: [:update, :destroy]
  before_action :apply_model_views, only: [:show, :update]

  # GET /fulfillment
  def index
    @models = Fulfillment.all
    render json: @models
  end

  # GET /fulfillment/1
  def show
    render json: @model.public
  end

  # POST /fulfillment
  def create
    # verify that the user owns either response or request
    require_fulfillment_ownership
    # in a transaction, create a Fulfillment record
    # and update status of Request and Response
    @model = FulfillmentPoster.new({response: @response, message: query_params[:message]})
    @model.poster_id = current_user

    if @model.save
      render json: @model.public, status: :created
    else
      render_validation_error(@model)
    end
  end

  # PATCH/PUT /fulfillment/1
  def update
    update_params = params.require(:fulfillment).permit(:message)
    if @model.update(update_params)
      render json: @model.public
    else
      render_validation_error(@model)
    end
  end

  # DELETE /fulfillment/1
  def destroy
    @model.destroy
  end

  private

  def query_params
    params.require(:fulfillment).permit(:response_id, :message)
  end

  def set_model
    @model = Fulfillment.find(params[:id])
  end

  def apply_model_views
    @model.extend(FulfillmentView)
  end

  def require_fulfillment_ownership
    response_id = query_params[:response_id]
    @response = Response.with_request.find(response_id)
    raise ApplicationController::ForbiddenError unless user_signed_in? && (@response.user == current_user || @response.request.user_id == current_user.id)
  end

end
