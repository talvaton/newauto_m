class StaticPagesController < ApplicationController
  def main_centr

  end

  def main_rcar

  end

  def trade_in

  end

  def credit

  end

  def leasing

  end

  def utilization

  end

  def sale

  end

  def contacts

  end

  def taxi

  end

  def load_cars_to_top
    @brandcars = Brand.find_by(title: params[:brandName]).new_cars.where(hide:0)
  end
end