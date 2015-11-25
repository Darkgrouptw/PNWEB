class PeoplelistController < ApplicationController
  def index
    @items = Dataitem.where(people: params[:people])
  end
end
