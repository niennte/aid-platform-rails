class AddPicToAccounts < ActiveRecord::Migration[5.2]
  def self.up
    add_attachment :accounts, :pic
  end

  def self.down
    remove_attachment :accounts, :pic
  end
end
