class BrandsController < ApplicationController
  include CreditHelper

  caches_action :index,:show,:show_credit,:show_tradein

  #breadcrumb 'Каталог новых авто', :newauto_path, match: :exclusive,except: [:show_credit,:show_tradein]

  def index
    @newcars = NewCar
                 .joins(:equipments)
                 .joins(:brand)
                 .select('(min(equipment.price) - `new_cars`.`discount_settings` -> "$.newauto.discount" - `new_cars`.`discount_settings` -> "$.newauto.credit" - `new_cars`.`discount_settings` -> "$.newauto.tradein" - 40000) as min_price,min(equipment.price) as min_price_no_discount,brands.url as brand_url,`new_cars`.*')
                 .where(hide: false)
                 .where('brands.hide = ?', false)
                 .where('equipment.hide = ?', 0)
                 .engine_type(params[:engine_type])
                 .transmission(params[:transmission])
                 .car_type(params[:type])
                 .having_price_range(params[:price_min],params[:price_max])
                 .group('new_cars.id')
                 .order('brands.title')
    @newauto_brands = Brand.find(@newcars.map{|d| d.brand_id}.uniq)
  end

  def show
    @brand = Brand.find_by(url: params[:brand])
    icons = ['Модельный ряд','Трейд-ин','Экспресс-кредит']
    if @current_region.id == 57
      icons.push('Новости')
    end

    @prev_path = set_prev_path

    @icons = sidenav_icons(icons)
    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb @brand.title, brand_path(@brand)
  end

  def show_credit
    @brand = Brand.find_by(url: params[:brand])
    icons = ['Модельный ряд','Трейд-ин','Экспресс-кредит']
    if @current_region.id == 57
      icons.push('Новости')
    end

    @prev_path = set_prev_path

    @icons = sidenav_icons(icons)
    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb 'Кредит', credit_path,match: :exclusive
    breadcrumb @brand.title, brand_credit_path(@brand)
  end

  def show_tradein
    @brand = Brand.find_by(url: params[:brand])
    icons = ['Модельный ряд','Трейд-ин','Экспресс-кредит']
    if @current_region.id == 57
      icons.push('Новости')
    end

    @prev_path = set_prev_path

    @icons = sidenav_icons(icons)
    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb 'Трейд ин', tradein_path,match: :exclusive
    breadcrumb @brand.title, brand_tradein_path(@brand)
  end

  def show_taxi
    @brand = Brand.find_by(url: params[:brand])
    icons = ['Модельный ряд','Трейд-ин','Экспресс-кредит']
    if @current_region.id == 57
      icons.push('Новости')
    end

    @prev_path = set_prev_path

    @icons = sidenav_icons(icons)
    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb 'Такси', taxi_path,match: :exclusive
    breadcrumb @brand.title, brand_taxi_path(@brand)
  end

end