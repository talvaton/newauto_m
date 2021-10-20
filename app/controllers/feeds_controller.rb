class FeedsController < ApplicationController
  def index

  end

  def yml_export
    @brands = Brand.where(id: ALLOWED_BRANDS).where(menu_show: true).order(:title)
    @new = NewCar.where(hide: 0).where(brand_id: ALLOWED_BRANDS)
    @used = UsedCar.used_cars
  end

  def xml_auto_ru
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).where(brand_id: ALLOWED_BRANDS).includes(:brand)
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
    @new = NewCar.where(feed: 1).where(hide: 0).where(available: 1).where(brand_id: ALLOWED_BRANDS).includes(:brand)
  end

  def xml_target
    @brands = Brand.where(id: ALLOWED_BRANDS).where(menu_show: true).order(:title)
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).where(brand_id: ALLOWED_BRANDS).includes(:brand)
  end

  def xml_yandex
    @brands = Brand.where(id: ALLOWED_BRANDS).where(menu_show: true).order(:title)
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).where(brand_id: ALLOWED_BRANDS).includes(:brand)
  end
  def xml_yandex_clone
    @brands = Brand.where(hide: 0).order(:title)
    @newcars = NewCar.where(hide: 0).includes(:brand)
  end
  def xml_vk
    @brands = Brand.where(id: ALLOWED_BRANDS).where(menu_show: true).order(:title)
    @newcars = NewCar.where(feed: 1).where(hide: 0).where(available: 1).where(brand_id: ALLOWED_BRANDS).includes(:brand)
  end

end