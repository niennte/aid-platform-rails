class AccountsController < ApplicationController
  before_action :require_authorization
  before_action :apply_model_views

  # GET /request/1
  def show
    render json: current_user.account.nil? ? {} : current_user.account.extend(AccountView).public
  end

  # POST /account
  def create
    @model = Account.new(query_params).extend(AccountView)
    @model.user = current_user
    if @model.save
      render json: @model.public, status: :created
    else
      render_validation_error(@model)
    end

  end

  # PATCH/PUT /account
  def update
    @model = current_user.account
    if @model.nil?
      raise ApplicationController::ResourceNotFoundError
    end
    if @model.update(query_params)
      render json: @model.extend(AccountView).public, status: :ok
    else
      render_validation_error(@model.extend(AccountView))
    end
  end

  # DELETE /account
  def destroy
    current_user.account.destroy
    render status: :no_content
  end

  private

  def query_params
    params.require(:account).permit(:first_name, :last_name, :pic)
  end

  def apply_model_views
    # @model.extend(AccountView)
  end

end
