class ResponsesController < ApplicationController
  before_action :require_authorization
  before_action :set_model, only: [:show, :update, :destroy]
  before_action :require_ownership, only: [:update, :destroy]
  before_action :apply_model_views, only: [:show, :update]

  # GET /response
  def index
    @models = Response.all
    render json: @models
  end

  # GET /response/1
  def show
    if @model
      render json: @model.public
    else
      render status: :not_found
    end
  end

  # POST /response
  def create
    @model = Response.new(query_params).extend(ResponseView)
    @model.user = current_user
    if @model.save
      render json: @model.public, status: :created
    else
      render_validation_error(@model)
    end

  end

  # PATCH/PUT /response/1
  def update
    if @model.update(query_params)
      render json: @model.public, status: :ok
    else
      render_validation_error(@model)
    end

  end

  # DELETE /response/1
  def destroy
    @model.destroy
    render status: :no_content
  end

  private

  def query_params
    params.require(:response).permit(:id, :request_id, :user_id, :message)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_model
    @model = Response.find(params[:id])
  end

  def apply_model_views
    @model.extend(ResponseView)
  end

end
