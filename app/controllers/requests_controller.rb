class RequestsController < ApplicationController
  before_action :require_authorization
  before_action :set_model, only: [:show, :update, :destroy]
  before_action :require_ownership, only: [:update, :destroy]
  before_action :apply_model_views, only: [:show, :update]

  # GET /request
  def index
    @models = Request.all
    render json: @models
  end

  # GET /request/1
  def show
    if @model
      render json: @model.public
    else
      render status: :not_found
    end
  end

  # POST /request
  def create
    @model = Request.new(query_params).extend(RequestView)
    @model.user = current_user
    if @model.save
      render json: @model.public, status: :created
    else
      render_validation_error(@model)
    end

  end

  # PATCH/PUT /request/1
  def update
    if @model.update(query_params)
      render json: @model.public, status: :ok
    else
      render_validation_error(@model)
    end

  end

  # DELETE /request/1
  def destroy
    @model.destroy
    render status: :no_content
  end

  private

  def query_params
    params.require(:request).permit(:id, :user_id, :category, :status, :title, :description, :address, :category)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_model
    @model = Request.find(params[:id])
  end

  def apply_model_views
    @model.extend(RequestView)
  end

end
