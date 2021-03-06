class WelcomeController < ApplicationController

  before_filter :authenticate_user!

  require 'net/http'
  require 'uri'

  def index
  end

  # Let's authenticate with Bitly.
  def oauth
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
  end
end