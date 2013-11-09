require 'json'
require 'rest-client'

class Takeout < ActiveRecord::Base
	has_many :histories
end
