require 'json'
require 'rest-client'

class Search < ActiveRecord::Base
	has_many :histories
end
