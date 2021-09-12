class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @items = Item.all.page(params[:page]).per(3)
    @tags = Tag.all

    if params[:search] == nil
      @items= Item.all
    elsif params[:search] == ''
      @items= Item.all
    else
      #部分検索
      search = params[:search]
        @items = Item.joins(:user).where("post_genre LIKE ? OR memo LIKE ?", "%#{search}%", "%#{search}%")
    end

    if params[:tag_ids]
      @items = []
      params[:tag_ids].each do |key, value|
        if value == "1"
          tag_items = Tag.find_by(name: key).items
          @items = @items.empty? ? tag_items : @items & tag_items
        end
      end
    end

    if params[:tag]
      Tag.create(name: params[:tag])
    end

    @items = @items.page(params[:page]).per(3)
  end

  def new
    @item = Item.new
  end

  def create
    item = Item.new(item_params)
    item.user_id = current_user.id
    if item.save
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def show
    @item = Item.find(params[:id])
    @comments = @item.comments
    @comment = Comment.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      redirect_to :action => "show", :id => item.id
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to action: :index
  end


  private
  def item_params
    params.require(:item).permit(:post_genre, :item_genre, :price, :status, :memo, :image, tag_ids: [])
  end

end
