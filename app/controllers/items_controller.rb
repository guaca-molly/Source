class ItemsController < ApplicationController
  before_action :force_login

  def index 
    # if theres a search filter
    if params[:q].present?
      # this is where we search
      @items = Item.where("lower(title) LIKE ?", "%" + params[:q].downcase + "%")
    else 
      #if not show all 
      @items = Item.all
    end 
  end 

  def show 
    @item = Item.find(params[:id])
  end 
end
