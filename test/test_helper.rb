ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def string_of(length)
    (0...length).map { ('a'..'z').to_a[rand(26)] }.join
  end

  def string_of_max(length)
    (-1...(rand(length))).map { ('a'..'z').to_a[rand(26)] }.join
  end

  def valid_email
    "#{string_of_max(9)}@#{string_of_max(9)}.#{string_of_max(5)}"
  end
end
