class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :bad_record_rescue


  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    if params[:user_id] 
      user = User.find(params[:user_id])
      item = user.items.find(params[:id])
    end
    render json: item
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(allowed_params)
    end
    render json: item, status: :created
  end



  private

  def allowed_params
    params.permit(:name, :description, :price)
  end

  def bad_record_rescue
    render json: { error: 'Not found' }, status:404
  end

end