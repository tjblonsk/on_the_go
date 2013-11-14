class SearchesController < ApplicationController

        before_filter :authenticate_user!

	def create
                code = params[:code]
                client_id = '6f4c7cb2694215156619c765d892ca62f56ea25b'
                client_secret = 'f1ab6494cc1af4a65a8d28ac5d58ca5ef633e11e'
                redirect_uri = 'http://on-the-go.herokuapp.com/oauth'
                uri = URI.parse('https://api-ssl.bitly.com/oauth/access_token')
                begin
                        https = Net::HTTP.new(uri.host, uri.port)
                        https.use_ssl = true
                        request = Net::HTTP::Post.new(uri.request_uri)
                        request.set_form_data({'client_id' => client_id, 'client_secret' => client_secret, 'redirect_uri' => redirect_uri, 'code' => code})
                        response = https.request(request)
                        puts "#{response.code} -- #{response.body}" #sanity check
                        @data = {}
                        response.body.split('&').each do |pair|
                                a = pair.split('=')
                                @data[a[0].to_sym] = a[1]
                        end
                        session[:token] = @data[:access_token]
                        redirect_to new_search_path
                rescue
                end


                @search = Search.new(search_params)
                #@search = Search.new(phrase: search_params["phrase"], limit: search_params["limit"])

		test_phrase = @search.phrase
		test_match = test_phrase.match(" ") ? "yes" : "no"
                while test_match == "yes" do
                        test_phrase[" "] = "%20"
                        test_match = test_phrase.match(" ") ? "yes" : "no"
                end
                @search.phrase = test_phrase

                bitly_url = "https://api-ssl.bitly.com/v3/search?access_token=#{session[:token]}&query=#{@search.phrase}&limit=#{@search.limit}"
                link_results = JSON.load(RestClient.get(bitly_url))
                results = link_results["data"]["results"].map do |set|
                        {title: set["title"], site: set["site"], url: set["url"]}
                end

                @search.save
                
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