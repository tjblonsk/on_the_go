class TakeoutsController < ApplicationController

	require 'rest-client'
	require 'json'

	def show
		@takeout = Takeout.find(params[:id])
	end

	def create
		@takeout = Takeout.new(takeout_params)
		test_phrase = @takeout.phrase
		test_match = test_phrase.match(" ") ? "yes" : "no"
        while test_match == "yes" do
        	test_phrase[" "] = "%20"
        	test_match = test_phrase.match(" ") ? "yes" : "no"
        end
        @takeout.phrase = test_phrase
        bitly_url = "https://api-ssl.bitly.com/v3/search?access_token=#{@access_token}&query=#{@takeout.phrase}&limit=#{@takeout.limit}"
        link_results = JSON.load(RestClient.get(bitly_url))
        results = bitly_url["data"]["results"].map do |set|
        	{title: set["title"], site: set["site"], url: set["url"]}
        end
	end

	def new
		@takeout = Takeout.new
	end

	private

	def takeout_params
		params.require('takeout').permit(:phrase, :limit, :token)
	end
end