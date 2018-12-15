class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|

      t.belongs_to :user, foreign_key: {on_delete: :cascade}, null: false
      t.string :title, :limit => 100, null: false
      t.text :description, :limit => 300, null: false
      t.string :address, null: false
      t.float :latitude
      t.float :longitude
      t.integer :category, null: false #enum defined in the model
      t.integer :status, null: false, default: 0 #enum defined in the model
      t.timestamps
    end
  end
end
