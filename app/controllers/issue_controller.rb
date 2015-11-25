class IssueController < ApplicationController
  def index
    @items = Dataitem.where(title: params[:title])
  end
end
