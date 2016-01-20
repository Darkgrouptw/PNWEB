class DataitemsController < ApplicationController
	def index
		@ans = params[:op]
	end
end
