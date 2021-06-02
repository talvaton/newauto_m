class RcarController < ApplicationController
  def main
    # puts 'test'
  end

  def load_cars_to_top
    @brandcars = Brand.find_by(title: params[:brandName]).new_cars.where(hide:0)
  end
end