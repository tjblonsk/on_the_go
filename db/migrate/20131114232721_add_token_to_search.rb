class AddTokenToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :token, :string
  end
end
