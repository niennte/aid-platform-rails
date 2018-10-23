class MessageDispatchesController < ApplicationController
  before_action :require_authorization
  before_action :set_model, only: [:show, :update, :destroy]
  before_action :require_ownership, only: [:update, :destroy, :show]
  before_action :apply_model_views, only: [:show, :update]

  # GET /dispatch
  def index
    @models = MessageDispatch.all

    render json: @models
  end

  # GET /dispatch/1
  def show
    if @model
      render json: @model.recursive
    else
      render status: :not_found
    end
  end

  # POST /dispatch
  def create
    @model = MessageDispatch.new(query_params).extend(MessageDispatchView)
    @model.user = current_user

    if @model.save
      render json: @model.public, status: :created
    else
      render_validation_error(@model)
    end
  end

  # PATCH/PUT /dispatch/1
  def update
    if @model.update(query_params)
      render json: @model.public
    else
      render_validation_error(@model)
    end
  end

  # DELETE /dispatch/1
  def destroy
    @model.destroy
    render status: :no_content
  end

  private

  def query_params
    params.require(:message).permit(:is_read)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_model
    @model = MessageDispatch.find(params[:id])
  end

  def apply_model_views
    @model.extend(MessageDispatchView)
  end

end
