module Exceptions
  class AuthenticationError < StandardError; end
  class ForbiddenError < StandardError; end
  class ResourceNotFoundError < StandardError; end
end