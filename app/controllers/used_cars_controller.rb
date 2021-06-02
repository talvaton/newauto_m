class UsedCarsController < ApplicationController
  caches_action :used,:used_brand,:used_year,:special,:special_brand,:special_model

  def used
    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)
    # @used = UsedCar.used_cars
    # @years = UsedCar.used_cars.select(:year).group(:year)
    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    # @year_filter = Brand.joins(:used_cars).where('used_cars.used = 1').select('brands.id,brands.title,brands.url').group('brands.id').order(:year)

    # puts @years.to_json
    breadcrumb 'БУ авто', sprobegom_path
  end

  def used_brand
    if params[:brand] === 'vaz-lada'
      @brand = Brand.find_by(url: 'vaz')
      redirect_to used_brand_path(@brand.url)
    else
      @brand = Brand.find_by(url: params[:brand])
    end

    @prev_path = sprobegom_path

    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)
    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    breadcrumb 'БУ авто', sprobegom_path
    breadcrumb @brand.title, used_brand_path(@brand.url)
  end

  def used_brand_model
    @brand = Brand.find_by(url: params[:brand])
    @model = params[:model]
    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)

    @prev_path = set_prev_path

    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    breadcrumb 'БУ авто', sprobegom_path
    breadcrumb @brand.title, used_brand_path(@brand.url), match: :exclusive
    breadcrumb @model, used_brand_model_path(@brand.url, @model)
  end

  def used_brand_year
    @brand = Brand.find_by(url: params[:brand])
    @year = params[:year]
    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)

    @prev_path = set_prev_path

    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    breadcrumb 'БУ авто', sprobegom_path
    breadcrumb @brand.title, used_brand_path(@brand.url), match: :exclusive
    breadcrumb @year, used_brand_year_path(@brand.url, @year)
  end

  def used_brand_model_year
    @brand = Brand.find_by(url: params[:brand])
    @model = params[:model]
    @year = params[:year]
    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)

    @prev_path = set_prev_path

    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    breadcrumb 'БУ авто', sprobegom_path
    breadcrumb @brand.title, used_brand_path(@brand.url)
    breadcrumb @model, used_brand_model_path(@brand.url, @model)
    breadcrumb @year, used_brand_model_year_path(@brand.url, @model, @year)
  end

  def used_year
    @year = params[:url]
    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)

    used_seo = JSON.parse(File.read(Rails.root + 'db/assets/years.json'))
    if used_seo.present?
      used_seo.each do |year|
        if year['title'] == @year
          used_seo = JSON.parse(year['used_seotext'])
          hash = {}
          hash['used_seotext_upper'] = used_seo[0]['Seotextblock']
          hash['used_seotext_lower'] = used_seo[1]['Seotextblock']
          @seo_text = hash
        end
      end
    end
    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    breadcrumb 'БУ авто', sprobegom_path
    breadcrumb @year, used_year_path(@year)
  end

  def used_price
    @price = params[:url]
    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)

    if @price.to_i == 150000
      price_start = 0
    elsif @price.to_i > 150000 && @price.to_i <= 1000000
      price_start = @price.to_i - 50000
    else
      price_start = @price.to_i - 500000
    end

    @used_price = UsedCar.used_cars(0).where("price > #{price_start} AND price <= #{@price.to_i}")

    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    breadcrumb 'БУ авто', sprobegom_path
    breadcrumb @price, used_price_path(@price)
  end

  def used_country
    @country = params[:url]
    countries = JSON.parse(File.read(Rails.root + 'db/assets/countries.json'))
    countries.each do |country|
      if country['url'] == @country
        @title = country['title']
        @brands_country = country['brands'].split(',')
      end
    end
    brands = Brand.where(title:@brands_country)
    @used_country = UsedCar.used_cars.where(brand_id: brands)

    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)

    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    breadcrumb 'БУ авто', sprobegom_path, match: :exclusive
    breadcrumb @title, used_country_path(@country)
  end

  def used_type
    @type = params[:url]
    types = JSON.parse(File.read(Rails.root + 'db/assets/types.json'))
    types.each do |type|
      if type['url'] == @type
        @title = type['title']
        @used_type = UsedCar.used_cars.where("car_type LIKE ?", '%'+ type['name'] +'%')
      end
    end

    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)

    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    breadcrumb 'БУ авто', sprobegom_path, match: :exclusive
    breadcrumb @title, used_type_path(@type)
  end

  def used_transmission
    @transmission = params[:url]
    if @transmission == 'mkpp'
      tr_name = 'MT'
      tr_name_rus = 'МКПП'
    elsif @transmission == 'akpp'
      tr_name = 'AT'
      tr_name_rus = 'АКПП'
    else
      tr_name = 'CVT'
      tr_name_rus = 'Вариатор'
    end
    @used_transmission = UsedCar.used_cars.where('`transmission` LIKE ?', '%' + tr_name + '%')

    @brand_filter = Brand.joins(:used_cars).where('used_cars.used = 1').where('used_cars.hide = 0').select('brands.id,brands.title,brands.url').group('brands.id').order(:title)

    @icons = sidenav_icons(['Авто с пробегом','Трейд-ин'])
    breadcrumb 'БУ авто', sprobegom_path, match: :exclusive
    breadcrumb tr_name_rus, used_transmission_path(@transmission)
  end

  def special
    @icons = sidenav_icons(['Спецпредложения','Экспресс-кредит','Банки'])
    breadcrumb 'Спецпредложения', deals_path
  end

  def special_brand
    @brand = Brand.find_by(url: params[:brand])
    @cars = UsedCar.special_cars.where(brand: @brand)

    @icons = sidenav_icons(['Спецпредложения','Экспресс-кредит','Банки'])
    breadcrumb 'Спецпредложения', deals_path, match: :exclusive
    breadcrumb 'Скидки на ' + @brand.title, special_brand_path(@brand.url)
  end

  def special_model
    @brand = Brand.find_by(url: params[:brand])
    @cars = UsedCar.special_cars.where(brand: @brand)
    @model = UsedCar.find_by(url: params[:model])

    @icons = sidenav_icons(['Спецпредложения','Экспресс-кредит','Банки'])
    breadcrumb 'Спецпредложения', deals_path, match: :exclusive
    breadcrumb 'Скидки на ' + @brand.title, special_brand_path(@brand.url), match: :exclusive
    breadcrumb "#{@model.name} в наличии", special_model_path(@brand.url,@model.url)

    # Views are the same
    render 'special_brand'
  end

  def show_modal
    @car = UsedCar.find(params[:id])
    case params[:modal]
    when 'used-car-details-modal'
      render "show_modal_desc"
    when 'used-car-details-modal_newprice'
      render "show_modal_desc_newprice"
    when 'used-car-buy-modal'
      render "show_modal_bron"
    else
      render "show_modal_photo"
    end
  end

  def show_filter_special
    if params[:brand].present?
      @res = UsedCar.where(hide: 0, used: 0).where(brand_id: Brand.find(params[:brand]))
    else
      @res = UsedCar.where(hide: 0, used: 0)
    end

    @res = @res.where('`transmission` LIKE ?', '%' + params[:transmission] + '%') if params[:transmission].present?
    @res = @res.where('`drive` LIKE ?', '%' + params[:drive] + '%') if params[:drive].present?
    # @res = @res.where('`enginetype` LIKE ?', '%' + params[:engine] + '%') if params[:engine].present?

    if params[:type].present?
      types = JSON.parse(File.read(Rails.root + 'db/assets/types.json'))
      types.each do |t|
        if t['url'] == params[:type]
          type = t['name']
          @res = @res.where('`car_type` LIKE ?', '%' + type + '%')
        end
      end
    end

    if params[:country].present?
      countries = JSON.parse(File.read(Rails.root + 'db/assets/countries.json'))
      countries.each do |c|
        if c['url'] == params[:country]
          brands = c['brands'].split(',')
          br = Brand.where(title:brands)
          @res = @res.where('`brand_id` IN (?)', br.ids)
        end
      end
    end

    @res = @res.where('`volume` >= ?', params[:volume_min].to_f) if params[:volume_min].present?
    @res = @res.where('`volume` <= ?', params[:volume_max].to_f) if params[:volume_max].present?
    @res = @res.where('`power` >= ?', params[:power_min].to_i) if params[:power_min].present?
    @res = @res.where('`power` <= ?', params[:power_max].to_i) if params[:power_max].present?
    @res = @res.where('`year` >= ?', params[:year_min].to_i) if params[:year_min].present?
    @res = @res.where('`year` <= ?', params[:year_max].to_i) if params[:year_max].present?

    @res = @res.where("`price` >= ?", params[:price_min].to_i) if params[:price_min].present?
    @res = @res.where("`price` <= ?", params[:price_max].to_i) if params[:price_max].present?

    @res = @res.order("RAND()").page(params[:page]).per(12)
    @total_pages = @res.total_pages

  end

  def show_filter_used
    if params[:brand].present?
      @res = UsedCar.where(hide: 0, used: 1).where(brand_id: Brand.find(params[:brand]))
    else
      @res = UsedCar.where(hide: 0, used: 1)
    end

    @res = @res.where('`transmission` LIKE ?', '%' + params[:transmission] + '%') if params[:transmission].present?
    @res = @res.where('`drive` LIKE ?', '%' + params[:drive] + '%') if params[:drive].present?
    # @res = @res.where('`enginetype` LIKE ?', '%' + params[:engine] + '%') if params[:engine].present?

    if params[:type].present?
      types = JSON.parse(File.read(Rails.root + 'db/assets/types.json'))
      types.each do |t|
        if t['url'] == params[:type]
          type = t['name']
          @res = @res.where('`car_type` LIKE ?', '%' + type + '%')
        end
      end
    end

    if params[:country].present?
      countries = JSON.parse(File.read(Rails.root + 'db/assets/countries.json'))
      countries.each do |c|
        if c['url'] == params[:country]
          brands = c['brands'].split(',')
          br = Brand.where(title:brands)
          @res = @res.where('`brand_id` IN (?)', br.ids)
        end
      end
    end

    @res = @res.where('`volume` >= ?', params[:volume_min].to_f) if params[:volume_min].present?
    @res = @res.where('`volume` <= ?', params[:volume_max].to_f) if params[:volume_max].present?
    @res = @res.where('`power` >= ?', params[:power_min].to_i) if params[:power_min].present?
    @res = @res.where('`power` <= ?', params[:power_max].to_i) if params[:power_max].present?
    @res = @res.where('`year` >= ?', params[:year_min].to_i) if params[:year_min].present?
    @res = @res.where('`year` <= ?', params[:year_max].to_i) if params[:year_max].present?
    @res = @res.where("`odometer` >= ?", params[:km_min].to_i) if params[:km_min].present?
    @res = @res.where("`odometer` <= ?", params[:km_max].to_i) if params[:km_max].present?
    @res = @res.where("`price` >= ?", params[:price_min].to_i) if params[:price_min].present?
    @res = @res.where("`price` <= ?", params[:price_max].to_i) if params[:price_max].present?

    @res = @res.order("RAND()").page(params[:page]).per(12)
    @total_pages = @res.total_pages

  end
end