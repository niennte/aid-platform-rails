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
    @model = Fulfillment.new(query_params).extend(FulfillmentView)
    @model.user = current_user

    if @model.save
      render json: @model.public, status: :created
    else
      render_validation_error(@model)
    end
  end

  # PATCH/PUT /fulfillment/1
  def update
    if @model.update(query_params)
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

  # Use callbacks to share common setup or constraints between actions.
  def set_model
    @model = Fulfillment.find(params[:id])
  end

  def apply_model_views
    @model.extend(FulfillmentView)
  end
end
