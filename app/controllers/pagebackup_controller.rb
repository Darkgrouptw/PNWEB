class PagebackupController < ApplicationController
  def index
  	@tags = params[:image_id]
  end
end
