class FeedsController < ApplicationController
  def index

  end

  def yml_export
    @brands = Brand.all
    @new = NewCar.where(hide: 0)
    @used = UsedCar.used_cars
  end

  def xml_auto_ru
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).includes(:brand)
    # @newcars = NewCar.where(hide: 0).where(available: 1).includes(:brand)
  end

  def xml_avito_ru
    @used = UsedCar.used_cars.where(avito: '1')
    #puts "Avito first used car: #{@used.first.name}"
  end

  def xml_cartraders_ru
    @used = UsedCar.used_cars
  end

  def csv_google
    @new = NewCar.where(feed: 1).where(hide: 0).where(available: 1).includes(:brand)
  end

  def xml_target
    @brands = Brand.all
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).includes(:brand)
  end

  def xml_yandex
    @brands = Brand.all
    @new = NewCar.where(hide: 0)
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).includes(:brand)
  end
  def xml_vk
    @brands = Brand.all
    @new = NewCar.where(hide: 0)
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).includes(:brand)
  end

end