class AddParsedGeoFieldsToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :full_address, :string
    add_column :requests, :city, :string
    add_column :requests, :postal_code, :string
    add_column :requests, :country, :string
  end
end
