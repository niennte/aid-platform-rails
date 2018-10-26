class AddStatusToResponse < ActiveRecord::Migration[5.2]
  def change
    add_column :responses, :status, :integer, null: false, default:0 #enum defined in the model
  end
end
