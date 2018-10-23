class CreateMessageDispatches < ActiveRecord::Migration[5.2]
  def change
    create_table :message_dispatches do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :message, foreign_key: true, null: false
      t.boolean :is_read, null: false, default: false

      t.timestamps
    end
  end
end
