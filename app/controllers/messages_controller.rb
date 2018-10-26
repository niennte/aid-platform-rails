class MessagesController < ApplicationController
  before_action :require_authorization
  before_action :set_model, only: [:show, :update, :destroy]
  before_action :require_ownership, only: [:update, :destroy, :show]
  before_action :apply_model_views, only: [:show, :update]

  # GET /messages
  def index
    @models = Message.with_dispatch.all_for_user(user: current_user)

    render json: (@models.map do |model|
      model.extend(MessageWithDispatchView).list
    end)
  end

  # GET /messages/1
  def show
    if @model.extend(MessageWithDispatchView)
      render json: @model.recursive
    else
      render status: :not_found
    end
  end

  # POST /messages
  # could be used for saving drafts
  def create
    @model = Message.new(query_params).extend(MessageView)
    @model.user = current_user

    if @model.save
      render json: @model.public, status: :created
    else
      render_validation_error(@model)
    end
  end

  # PATCH/PUT /messages/1
  # could be used for menaging drafts
  def update
    if @model.update(query_params)
      render json: @model.public
    else
      render_validation_error(@model)
    end
  end

  # DELETE /messages/1
  # could be used for deleting drafts
  def destroy
    @model.destroy
    render status: :no_content
  end

  private

  def query_params
    params.require(:message).permit(:subject, :body)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_model
    @model = Message.with_dispatch.find(params[:id])
  end

  def apply_model_views
    @model.extend(MessageView)
  end

end
