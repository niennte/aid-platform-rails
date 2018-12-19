# assumes the test implements valid_model, valid_fields, and invalid_fields
module ModelHelper

  def standard_validation(field)
    # take a valid model
    model = @valid_model

    # iterate over each field that it should reject
    @invalid[field].each do |value|
      # assign the value to the specified field
      model.send "#{field}=", value
      # make sure it is rejected
      refute model.valid?
      assert model.errors[field].any?
    end
  end

end