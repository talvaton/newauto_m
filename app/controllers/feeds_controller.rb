class FeedsController < ApplicationController
  def index

  end

  def yml_export
    allowed_ids = [4,10,13,14,15,16,18,21,22,23,25,26,27,28,32,36]
    @brands = Brand.where(id: allowed_ids).where(menu_show: true).order(:title)
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
    allowed_ids = [4,10,13,14,15,16,18,21,22,23,25,26,27,28,32,36]
    @brands = Brand.where(id: allowed_ids).where(menu_show: true).order(:title)
    #@brands = Brand.all
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).includes(:brand)
  end

  def xml_yandex
    allowed_ids = [4,10,13,14,15,16,18,21,22,23,25,26,27,28,32,36]
    @brands = Brand.where(id: allowed_ids).where(menu_show: true).order(:title)
    @new = NewCar.where(hide: 0)
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).includes(:brand)
  end
  def xml_vk
    allowed_ids = [4,10,13,14,15,16,18,21,22,23,25,26,27,28,32,36]
    @brands = Brand.where(id: allowed_ids).where(menu_show: true).order(:title)
    @new = NewCar.where(hide: 0)
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).includes(:brand)
  end

end