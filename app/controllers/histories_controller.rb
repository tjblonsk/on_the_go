class HistoriesController < ApplicationController

	before_filter :authenticate_user!

# Let's show history of previous searches.
	def index
		@histories = History.all
	end

# Let's show results of current search.
	def show
		@histories = History.where("search_id = #{params[:id]}")
	end

end