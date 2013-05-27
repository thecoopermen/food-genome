class FoodController < ApplicationController

  def index
    @food = Food.all
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(params[:food])
    if @food.save
      redirect_to food_index_path, notice: "#{@food.name} successfully created"
    else
      render :new
    end
  end
end
