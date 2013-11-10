class RenameSearchesColumnName < ActiveRecord::Migration
  def change
  	rename_column :histories, :searches_id, :search_id
  end
end
