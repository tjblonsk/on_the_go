class HistoriesController < ApplicationController

	def index
		@histories = History.all
	end

	def show
		@histories = History.where("search_id = #{params[:id]}")
	end

end