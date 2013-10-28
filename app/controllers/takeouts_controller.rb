class TakeoutsController < ApplicationController

	def show
		@takeout = Takeout.find(params[:id])
	end

	def create
		@takeout = Takeout.new(takeout_params)
	end

	def new
		@takeout = Takeout.new
	end

	private

	def takeout_params
		params.require('takeout').permit(:phrase, :limit, :token)
	end
end