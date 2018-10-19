# override default Devise registrations controller
# so as to be able to customize it
class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    # this is inherited from DeviseController
    resource.save
    render_resource(resource)
  end

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:username, :email, :password, :current_password)
  end
end