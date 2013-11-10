class TakeoutHasManyHistories < ActiveRecord::Migration
  def change
  	add_reference :histories, :searches
  end
end
