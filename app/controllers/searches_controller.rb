class SearchesController < ApplicationController

        before_filter :authenticate_user!

# Let's do our search.
	def create

                @search = Search.new(search_params)

                # Let's check for spaces.
		test_phrase = @search.phrase
		test_match = test_phrase.match(" ") ? "yes" : "no"
                while test_match == "yes" do
                        test_phrase[" "] = "%20"
                        test_match = test_phrase.match(" ") ? "yes" : "no"
                end
                @search.phrase = test_phrase

                # Let's do our API call.
                bitly_url = "https://api-ssl.bitly.com/v3/search?access_token=#{session[:token]}&query=#{@search.phrase}&limit=#{@search.limit}"
                link_results = JSON.load(RestClient.get(bitly_url))
                results = link_results["data"]["results"].map do |set|
                        {title: set["title"], site: set["site"], url: set["url"]}
                end

                # Let's save to our search table.
                @search.save
                
                # Let's save our search results to pur history table.
                results.each do |result|
                        History.create title: result[:title], site: result[:site], url: result[:url], search_id: @search.id
                end

                if @search.save
                        redirect_to "/histories/#{@search.id}" 
                else
                        render :new
                end
        end

	def new
		@search = Search.new
	end

	private

	def search_params
		params.require('search').permit(:phrase, :limit)
	end
end