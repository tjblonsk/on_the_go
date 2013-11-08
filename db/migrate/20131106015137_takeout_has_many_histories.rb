class TakeoutHasManyHistories < ActiveRecord::Migration
  def change
  	add_reference :histories, :takeout
  end
end
