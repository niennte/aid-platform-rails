require 'test_helper'
require 'helpers/model_helper'

class RequestTest < ActiveSupport::TestCase
  include ModelHelper

  fixtures :users

  setup do

    # Stub Geocoder
    Geocoder.configure(:lookup => :test)
    Geocoder::Lookup::Test.add_stub(
      'Toronto, Ontario', [
        {
          latitude: 43.653963,
          longitude: -79.387207,
          address: 'Toronto, Ontario, M6K 1X9, Canada',
          city: 'Toronto',
          postal_code: 'M6K 1X9',
          country: 'Canada',
          country_code: 'CA'
        }
      ]
    )

    # Generate random values meeting validation criteria
    @valid = build_valid_fields

    # Generate random values representing edge cases
    @invalid = build_invalid_fields

    # Create reusable valid model for isolation in edge cases
    @valid_model = sample_valid_model

    # Turn off observers subscribed by the model
    Wisper.clear
  end


  test 'is valid' do
    model = @valid_model
    assert model.valid?
  end

  test 'is invalid unless USER valid' do
    standard_validation :user
  end

  test 'is invalid unless TITLE valid' do
    standard_validation :title
  end

  test 'is invalid unless DESCRIPTION valid' do
    standard_validation :description
  end

  test 'is invalid unless ADDRESS is provided' do
    standard_validation :address
  end

  test 'is invalid unless CATEGORY is set' do
    standard_validation :category
  end

  private

  def build_valid_fields
    {
      user: [users(:one), users(:two)],
      title: [string_of_max(100)],
      description: [string_of_max(300)],
      address: ['Toronto, Ontario'],
      category: [Request.categories.key(rand(0..1))]
    }
  end

  def build_invalid_fields
    {
      user: [
          nil,
      ],
      title: [
          nil,
          string_of(101)
      ],
      description: [
          nil,
          string_of(301)
      ],
      address: [
          nil,
      ],
      category: [
          nil,
      ]
    }
  end

  def sample_valid_model
    Request.new(
      user: @valid[:user][rand(@valid[:user].length)],
      title: @valid[:title][rand(@valid[:title].length)],
      description: @valid[:description][rand(@valid[:description].length)],
      address: @valid[:address][rand(@valid[:address].length)],
      category: @valid[:category][rand(@valid[:category].length)]
    )
  end

end