class ApplicationController < ActionController::API
  AuthenticationError = Class.new(Exceptions::AuthenticationError)
  ForbiddenError = Class.new(Exceptions::ForbiddenError)
  ResourceNotFoundError = Class.new(Exceptions::ResourceNotFoundError)

  rescue_from ApplicationController::AuthenticationError do |exception|
    render json: {
        errors: [
            {
                status: '401',
                title: 'Unauthorized',
                detail: {
                    'AUTHENTICATION': 'Please login to continue.'
                },
                code: 'AUTHENTICATION'
            }
        ]
    }, status: :unauthorized
  end

  rescue_from ApplicationController::ForbiddenError do |exception|
    render json: {
        errors: [
            {
                status: '403',
                title: 'Forbidden',
                detail: {
                    'AUTHORIZATION': 'The requested action is reserved to the resource owner.'
                },
                code: 'AUTHORIZATION'
            }
        ]
    }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {
        errors: [
            {
                status: '404',
                title: 'Not found',
                detail: {
                    'NO_RESULT': 'The resource you requested doesn\'t exist.',
                    message: exception.message,
                },
                code: 'NO_RESULT'
            }
        ]
    }, status: :not_found
  end

  rescue_from ApplicationController::ResourceNotFoundError do |exception|
    render json: {
        errors: [
            {
                status: '404',
                title: 'Not found',
                detail: {
                    'NO_RESULT': 'The resource you requested doesn\'t exist.',
                    message: exception.message,
                },
                code: 'NO_RESULT'
            }
        ]
    }, status: :not_found
  end

  # thrown by ActiveRecord to deal with enums
  rescue_from ArgumentError do |exception|
    render json: {
        errors: [
            {
                status: '422',
                title: 'Unprocessable entity',
                detail: {
                    VALIDATION: 'Please correct the following errors:',
                    message: exception.message
                },
                code: 'VALIDATION'
            }
        ]
    }, status: :not_found
  end


  # generic error handling
  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
        errors: [
            {
                status: '422',
                title: 'Unprocessable entity',
                detail: {
                    VALIDATION: 'Please correct the following errors:',
                    errors: resource.errors
                },
            code: 'VALIDATION'
            }
        ]
    }, status: :unprocessable_entity
  end

  # API resource error handling
  def render_validation_error(resource)
    render json: {
        errors: [
            {
                status: '422',
                title: 'Unprocessable entity',
                detail: {
                    VALIDATION: 'Please correct the following errors:',
                    errors: resource.errors,
                    resource: resource.editable,
                },
                code: 'VALIDATION'
            }
        ]
    }, status: :unprocessable_entity
  end

  def require_authorization
    raise ApplicationController::AuthenticationError unless user_signed_in?
  end

  def require_ownership
    raise ApplicationController::ForbiddenError unless user_signed_in? && @model.user == current_user
  end

end
