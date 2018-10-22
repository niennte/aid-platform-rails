class CreateFulfillments < ActiveRecord::Migration[5.2]
  def change
    create_table :fulfillments do |t|
      t.belongs_to :response, foreign_key: {on_delete: :cascade}, null: false
      t.belongs_to :user, foreign_key: {on_delete: :restrict}, null: false
      t.text :message, null: false, default: ''
      t.timestamps
    end
  end
end
