class MessageDispatchesController < ApplicationController
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: true)

  before_action :require_authorization
  before_action :set_model, only: [:show, :update, :destroy]
  before_action :require_ownership, only: [:update, :destroy, :show]
  before_action :apply_model_views, only: [:show, :update]

  # GET /inbox
  def index
    @models = MessageDispatch.with_message.all_for_user(user: current_user)

    render json: (@models.map do |model|
      model.extend(MessageDispatchView).list
    end)
  end

  # GET /inbox/1
  def show
    if @model
      render json: @model.recursive
    else
      render status: :not_found
    end
  end

  # POST /inbox
  def create
    # create operates on two models and has unique set of params
    create_params = params.require(:message).permit(:recipient_id, :body, :subject)
    @model = MessageDispatcher.new(create_params)
    @model.sender_id = current_user.id

    if @model.save
      # inbox_new_add
      publish(:inbox_unread_add, @model.recipient_id)
      render json: @model.public, status: :created
    else
      render_validation_error(@model)
    end
  end

  # PATCH/PUT /inbox/1
  def update
    # only update the status of being read
    update_params = params.require(:message).permit(:is_read)
    if @model.update(update_params)
      render json: @model.public
    else
      render_validation_error(@model)
    end
  end

  # DELETE /inbox/1
  def destroy
    is_read = @model.is_read
    @model.destroy
    unless is_read
      publish(:inbox_unread_remove, @model.user_id)
    end
    render status: :no_content
  end

  private

  def set_model
    @model = MessageDispatch.with_message.find(params[:id])
  end

  def apply_model_views
    @model.extend(MessageDispatchView)
  end

  def true?(param)
    param.to_s == 'true'
  end

end
