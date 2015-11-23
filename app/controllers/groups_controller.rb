class GroupsController < ApplicationController
  def index
    @items = Dataitem.all
  end
end
