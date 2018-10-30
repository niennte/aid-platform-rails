class RequestsController < ApplicationController
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: Rails.env.production?)

  before_action :require_authorization
  before_action :set_model, only: [:update, :destroy, :activate]
  before_action :require_ownership, only: [:update, :destroy, :activate]
  before_action :apply_model_views, only: [:show, :update, :destroy, :activate]

  # GET /request-own
  def list
    @models = Request.with_user_and_num_responses.all_for_user(user: current_user)
    render json: (@models.map do |model|
      model.extend(RequestWithResponsesView).list
    end)
  end

  # GET /activate/1
  def activate
    request_activator = RequestActivator.new(@model)
    if request_activator.save
      publish(:request_update, request_activator.async)
      render json: request_activator.public, status: :ok
    else
      render_validation_error(request_activator)
    end
  end

  # GET /request
  def index
    @models = Request.with_user_and_num_responses.all_active
    render json: (@models.map do |model|
      model.extend(RequestWithResponsesView).list
    end)
  end

  # GET /request/1
  def show
    # Needs another model?
    @model = Request.with_user.with_fulfillment.find(params[:id])
    is_own = @model.user_id == current_user.id
    if @model
      @model.extend(RequestWithResponsesView)
      render json: (is_own ? @model.recursive : @model.summary)
    else
      render status: :not_found
    end
  end

  # POST /request
  def create
    @model = Request.new(query_params).extend(RequestView)
    @model.user = current_user
    if @model.save
      publish(:request_create, @model.async)
      render json: @model.recursive, status: :created
    else
      render_validation_error(@model)
    end

  end

  # PATCH/PUT /request/1
  def update
    if @model.update(query_params)
      publish(:request_update, @model.async)
      render json: @model.public, status: :ok
    else
      render_validation_error(@model)
    end

  end

  # DELETE /request/1
  def destroy
    @model.destroy
    publish(:request_destroy, @model.async)
    render status: :no_content
  end

  private

  def query_params
    params.require(:request).permit(:category, :title, :description, :address, :category)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_model
    @model = Request.find(params[:id])
  end

  def apply_model_views
    @model.extend(RequestView)
  end

end
