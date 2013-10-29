class Takeout < ActiveRecord::Base

	attr_accessor :access_token, :phrase, :limit

	# Lets initialize our variables
	def initialize(access_token, phrase, limit)
		@phrase = phrase
		@limit = limit
		@access_token = access_token
		@search_link = "https://api-ssl.bitly.com/v3/search?access_token=#{@access_token}&query=#{@phrase}&limit=#{@limit}"
	end

	# Let's define our search method
	def search
		bitly_link = JSON.load(RestClient.get(@search_link))
		results = bitly_link["data"]["results"].map do |set|
			{title: set["title"], site: set["site"], url: set["url"]}
		end
		show results
	end
end
