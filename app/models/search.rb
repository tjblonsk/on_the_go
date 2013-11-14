require 'json'
require 'rest-client'

class Search < ActiveRecord::Base
	validates_presence_of :search, :limit
	validates :limit, numericality: { greater_than: 0, only_interger: true }

	has_many :histories
end
