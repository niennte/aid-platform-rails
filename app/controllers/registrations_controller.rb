# override default Devise registrations controller
# so as to be able to customize it
class RegistrationsController < Devise::RegistrationsController
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: Rails.env.production?)

  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save
    if resource.errors.empty?
      publish :user_create
      # sign in user and return the token
      if resource.active_for_authentication?
        sign_in(resource_name, resource)
      end
      respond_with resource
    else
      validation_error(resource)
    end
  end

  def destroy
    super
    publish :user_destroy
  end

  private

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:username, :email, :password, :current_password)
  end

  def respond_with(resource, _opts = {})
    render json: resource
  end

end