class HistoriesController < ApplicationController
	
	before_filter :authenticate_user!

	def index
		@histories = History.all
	end

	def show
		@histories = History.where("search_id = #{params[:id]}")
	end

end