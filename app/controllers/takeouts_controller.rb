class TakeoutsController < ApplicationController

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
        bitly_url = "https://api-ssl.bitly.com/v3/search?access_token=#{@takeout.token}&query=#{@takeout.phrase}&limit=#{@takeout.limit}"
        link_results = JSON.load(RestClient.get(bitly_url))
        results = link_results["data"]["results"].map do |set|
        	{title: set["title"], site: set["site"], url: set["url"]}
        end
        if @takeout.save
        	redirect_to @takeout
        else
        	render :new
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