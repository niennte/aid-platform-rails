# override default Devise registrations controller
# so as to be able to customize it
class RegistrationsController < Devise::RegistrationsController
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: Rails.env.production?)

  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      publish :user_create
    end
    render_resource(resource)
  end

  def destroy
    super
    publish :user_destroy
  end

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:username, :email, :password, :current_password)
  end
end