class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.belongs_to :user, foreign_key: {on_delete: :cascade}, null: false
      t.string :first_name, :limit => 100, null: false
      t.string :last_name, :limit => 100, null: false

      t.timestamps
    end
  end
end
