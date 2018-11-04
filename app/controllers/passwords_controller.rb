# override default Devise passwords controller
# so as to be able to customize it
class PasswordsController < Devise::PasswordsController
  respond_to :json

  # POST /password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: {
        result: [
          {
            status: '200',
            title: 'Success',
            detail: {
              message: 'Email has been sent.'
            }
          }
        ]
      }, status: :ok
    else
      validation_error(resource)
    end
  end

  # PUT /password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        sign_in(resource_name, resource)
        respond_with resource
      else
        render json: {
          result: [
            {
              status: '200',
              title: 'Success',
              detail: {
                  message: 'Password has been updated.'
              }
            }
          ]
        }, status: :ok
      end
    else
      set_minimum_password_length
      validation_error(resource)
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

end