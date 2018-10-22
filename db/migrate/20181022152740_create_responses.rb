class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.belongs_to :request, foreign_key: {on_delete: :restrict}, null: false
      t.belongs_to :user, foreign_key: {on_delete: :restrict}, null: false
      t.text :message, null: false, default: ''

      t.timestamps
    end
  end
end
