class DataitemsController < ApplicationController
  def index
    @items = Dataitem.all
  end

  def show
  end

  def new
    @items = Dataitem.new
  end
   
  def edit
  end

  def create
    @items = Dataitem.create(dataitem_params)
    @items.count = 0

    if @items.save
      redirect_to dataitems_path, notice: '新增討論版成功'
    else
      render :new, notice: '新增失敗'
    end
  end

  def update
  end
  
  def destroy
    @items = Dataitem.find(params[:id])
    @items.destroy
    redirect_to dataitems_path, alert: "議題已刪除"
  end

  private
  
  def dataitem_params 
    params.require(:dataitem).permit(:title,
     :people,
     :is_support,
     :content,
     :count,
     :link)
  end
end
