class AddRequestToFulfillment < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :fulfillments, :request, foreign_key: {on_delete: :cascade}, null: false
  end
end
