class RemoveTokenFromSearch < ActiveRecord::Migration
  def change
    remove_column :searches, :token, :string
  end
end
