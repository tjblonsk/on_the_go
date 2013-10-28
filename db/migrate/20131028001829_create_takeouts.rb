class CreateTakeouts < ActiveRecord::Migration
  def change
    create_table :takeouts do |t|
      t.string :phrase
      t.integer :limit
      t.string :token

      t.timestamps
    end
  end
end
