class RenameTakeoutsToSearches < ActiveRecord::Migration
  def self.up
  	rename_table :takeouts, :searches
  end

  def self.down
  	rename_table :searches, :takeouts
  end
end
