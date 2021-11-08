class FeedsController < ApplicationController
  before_action :feeder

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

  end

  def xml_yandex

  end

  def xml_yandex_clone

  end

  def xml_vk

  end

  def feeder
    @brands = Brand.where("hide_settings -> '$.newauto' = ?", "false").where(menu_show: true).order(:title)
    @newcars = NewCar.where("feed_settings -> '$.newauto' = ?", "true").where("new_cars.hide_settings -> '$.newauto' = ?", "false").where(available: 1).where(brand_id: @brands.ids).includes(:brand)
  end
end