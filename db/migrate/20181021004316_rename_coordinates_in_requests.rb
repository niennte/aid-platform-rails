class RenameCoordinatesInRequests < ActiveRecord::Migration[5.2]
  def change
    rename_column :requests, :longitude, :lng
    rename_column :requests, :latitude, :lat
  end
end
