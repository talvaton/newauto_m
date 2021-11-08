class FeedsController < ApplicationController
  before_action :feeder

  def index

  end

  def yml_export
  end

  def xml_auto_ru
  end

  def xml_avito_ru
  end

  def xml_cartraders_ru
  end

  def csv_google
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