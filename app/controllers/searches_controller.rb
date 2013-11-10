class SearchesController < ApplicationController

	def show
                @history = History.all
	end

	def create
		@search = Search.new(search_params)

		test_phrase = @search.phrase
		test_match = test_phrase.match(" ") ? "yes" : "no"
                while test_match == "yes" do
                        test_phrase[" "] = "%20"
                        test_match = test_phrase.match(" ") ? "yes" : "no"
                end
                @search.phrase = test_phrase

                bitly_url = "https://api-ssl.bitly.com/v3/search?access_token=#{@search.token}&query=#{@search.phrase}&limit=#{@search.limit}"
                link_results = JSON.load(RestClient.get(bitly_url))
                results = link_results["data"]["results"].map do |set|
                        {title: set["title"], site: set["site"], url: set["url"]}
                end

                id = @search_id
                
                results.each do |result|
                        History.create title: result[:title], site: result[:site], url: result[:url], search_id: id
                end

                if @search.save
                        redirect_to @search
                else
                        render :new
                end
        end

	def new
		@search = Search.new
	end

	private

	def search_params
		params.require('search').permit(:phrase, :limit, :token)
	end
end