class BrandsController < ApplicationController
  include CreditHelper

  caches_action :index,:show,:show_credit,:show_tradein

  #breadcrumb 'Каталог новых авто', :newauto_path, match: :exclusive,except: [:show_credit,:show_tradein]

  def index
    @newcars = NewCar
                 .joins(:equipments)
                 .joins(:brand)
                 .select('(min(equipment.price) - `new_cars`.`discount_3` - `new_cars`.`discount_credit_3` - `new_cars`.`discount_tradein_3` - 40000) as min_price,min(equipment.price) as min_price_no_discount,brands.url as brand_url,`new_cars`.*')
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

  def show_filter
    if params[:brand].present?
      @res = Equipment.where(hide: 0).joins(:equipment_description).joins(:specification).joins(:new_cars)
                .where(equipment_descriptions: {new_car_id: NewCar.where(hide:0, archive: 0).where(brand_id: Brand.find(params[:brand]))})
    else
      @res = Equipment.where(hide: 0).joins(:equipment_description).joins(:specification).joins(:new_cars)
                 .where(equipment_descriptions: {new_car_id: NewCar.where(hide:0, archive: 0)})
    end

    @res = @res.where('`specifications`.`transmission` LIKE ?', '%' + params[:transmission] + '%') if params[:transmission].present?
    @res = @res.where('`specifications`.`drive` LIKE ?', '%' + params[:drive] + '%') if params[:drive].present?
    @res = @res.where('`specifications`.`enginetype` LIKE ?', '%' + params[:engine] + '%') if params[:engine].present?

    if params[:type].present?
      types = JSON.parse(File.read(Rails.root + 'db/assets/types.json'))
      types.each do |t|
        if t['url'] == params[:type]
          type = t['name']
          @res = @res.where('`new_cars`.`car_type` LIKE ?', '%' + type + '%')
        end
      end
    end

    if params[:country].present?
      countries = JSON.parse(File.read(Rails.root + 'db/assets/countries.json'))
      countries.each do |c|
        if c['url'] == params[:country]
          brands = c['brands'].split(',')
          br = Brand.where(title:brands)
          @res = @res.where('`new_cars`.`brand_id` IN (?)', br.ids)
        end
      end
    end

    @res = @res.where('ROUND(`specifications`.`volume`, -2) / 1000.0 >= ?', params[:volume_min].to_f) if params[:volume_min].present?
    @res = @res.where('ROUND(`specifications`.`volume`, -2) / 1000.0 <= ?', params[:volume_max].to_f) if params[:volume_max].present?
    @res = @res.where('`specifications`.`power` >= ?', params[:power_min].to_i) if params[:power_min].present?
    @res = @res.where('`specifications`.`power` <= ?', params[:power_max].to_i) if params[:power_max].present?

    @res = @res.where("`price` - `new_cars`.`discount_3` - `new_cars`.`discount_credit_3` - `new_cars`.`discount_tradein_3` - 30000 - #{@region_discount} >= ?", params[:price_min].to_i) if params[:price_min].present?
    @res = @res.where("`price` - `new_cars`.`discount_3` - `new_cars`.`discount_credit_3` - `new_cars`.`discount_tradein_3` - 30000 - #{@region_discount} <= ?", params[:price_max].to_i) if params[:price_max].present?

    @res = @res.order("RAND()").page(params[:page]).per(10)
    @total_pages = @res.total_pages

  end

end