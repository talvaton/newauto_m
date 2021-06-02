class CarsoController < ApplicationController
  # before_action :tradein_used,only: [:tradein]

  caches_action :main,:do,:do_type,:topsales,:credit,:credit_select,:first_auto,:family_auto,:utilization,:stock,:contacts,:policy,:corporate,:taxi
  caches_action :tradein,unless: -> { request.format.js? }


  def main
    # @special = UsedCar.where(used: 0).limit(8)
    #@special = UsedCar.special_cars(8)
    @special = UsedCar.special_cars.order("updated_at ASC").last(8)
    @latest_news = Story.order("created_at ASC").last(3)
    @reviews = Review.order(created_at: :desc).limit(6)
    @reviews_video = Review.order(video_link: :desc)
    icons = ['Хиты продаж','Трейд-ин', 'Спецпредложения', 'Экспресс-кредит', 'Банки',
                            'Преимущества']
    if @current_region.id == 57
      icons.push('Новости')
    end
    @icons = sidenav_icons(icons)
  end

  def get_filter_groups(car)
    @equipments = Equipment.joins(:equipment_description).where(hide:0)
                      .where('`equipment_descriptions`.`new_car_id` = ?', car.id)
    # сортировка комплектаций в 4 группы
    compl_arr = []
    @equipments.each do |e|
      compl_arr.push(e.id)
    end
    compl_arr = compl_arr.sort

    @compl_groups = [[],[],[],[],[]]
    compl_arr.each_with_index do |c, ind|
      if (ind+1) % 5  == 0
        @compl_groups[4].push(c)
      elsif (ind+1) % 4  == 0
        @compl_groups[3].push(c)
      elsif (ind+1) % 3  == 0
        @compl_groups[2].push(c)
      elsif (ind+1) % 2  == 0
        @compl_groups[1].push(c)
      else
        @compl_groups[0].push(c)
      end
    end

    # сортировка цветов в 4 группы
    ugly_colors = ['yellow', 'orange', 'brown', 'violet', 'blue', 'red']
    @color_groups = [[],[],[],[],[]]
    car.color_options.each_with_index do |c, ind|

      if ugly_colors.index(c['color_type'])
        if (ind+1) % 2  == 0
          @color_groups[3].push(ind)
        else
          @color_groups[4].push(ind)
        end
      else
        if (ind+1) % 3  == 0
          @color_groups[2].push(ind)
        elsif (ind+1) % 2  == 0
          @color_groups[1].push(ind)
        else
          @color_groups[0].push(ind)
        end
      end

    end

  end

  def show_filter
    @models = Brand.find(params[:brand]).new_cars.where(hide: 0, archive:0) if params[:brand].present?

    if params[:model].present?
      @car = NewCar.find(params[:model])
      get_filter_groups(@car)

      @res = Equipment.where(hide: 0).joins(:equipment_description).joins(:specification)
                 .where('`equipment_descriptions`.`new_car_id` = ?', @car.id)

      @res = @res.where('`equipment_descriptions`.`name` = ?', params[:compl]) if params[:compl].present?
      @res = @res.where('`specifications`.`transmission` = ?', params[:transmission]) if params[:transmission].present?
      @res = @res.where('ROUND(`specifications`.`volume`, -2) / 1000.0 = ?', params[:volume]) if params[:volume].present?
      @res = @res.where('`specifications`.`drive` = ?', params[:drive]) if params[:drive].present?
    end
  end

  def get_price_range(price)
    price_end = price
    if price == 300000
      price_start = 0
    elsif price > 300000 && price <= 700000
      price_start = price - 50000
    elsif price > 700000 && price <= 1200000
      price_start = price - 100000
    elsif price > 1200000 && price <= 1300000
      price_start = price - 50000
    elsif price > 1300000 && price <= 1500000
      price_start = price - 100000
    elsif price == 1700000
      price_start = price - 200000
    elsif price == 2000000
      price_start = price - 300000
    elsif price > 2000000
      price_start = price - 500000
    elsif price == 3000000
      price_start = price - 500000
      price_end = 10000000
    end
    return price_start, price_end
  end

  def do
    @price = params[:number]
    prices = get_price_range(@price.to_i)

    @do_price = NewCar.price_range(prices[0], prices[1])

    @do_price_lower = NewCar.price_range((prices[0]-150000), prices[0])

    @do_price_higher = NewCar.price_range(prices[1], (prices[1]+100000))

    @special_cars = UsedCar.special_cars(12).where("price > #{prices[0]} AND price <= #{prices[1]}")

    specials_icon = 'Спецпредложения'
    unless @special_cars.present?
      specials_icon = ''
    end

    texts = JSON.parse(File.read(Rails.root + 'db/assets/prices.json'))
    texts.each do |text|
      if text['title'] == @price
        @text = JSON.parse(text['seotext'])[0]['Seotextblock']
      end
    end

    @icons = sidenav_icons([specials_icon, 'Трейд-ин'])
    breadcrumb @price, do_path(@price)
  end

  def do_type
    @price = params[:number]
    @type = params[:type]
    types = JSON.parse(File.read(Rails.root + 'db/assets/types.json'))
    types.each do |type|
      if type['url'] == @type
        @title = type['title']
        @name = type['name']
      end
    end

    prices = get_price_range(@price.to_i)

    @do_type_price = NewCar.price_range(prices[0], prices[1]).where("car_type LIKE ?", '%'+ @name +'%')

    @do_type_price_lower = NewCar.price_range((prices[0]-150000), prices[0]).where("car_type LIKE ?", '%'+ @name +'%')

    @do_type_price_higher = NewCar.price_range(prices[1], (prices[1]+100000)).where("car_type LIKE ?", '%'+ @name +'%')

    @special_type_cars = UsedCar.special_cars(12).where("car_type LIKE ?", '%'+ @name +'%')
                                                .where("price > #{prices[0]} AND price <= #{prices[1]}")

    specials_icon = 'Спецпредложения'
    unless @special_type_cars.present?
      specials_icon = ''
    end

    @icons = sidenav_icons([specials_icon, 'Трейд-ин'])


    breadcrumb @title, new_car_type_path(params[:type]),match: :exclusive
    breadcrumb @price, do_type_path(params[:type],@price)
  end

  def topsales
    @hits = NewCar.where("`new_cars`.`special_options` LIKE ?",'%Хит-продаж%').where(hide: 0)
    @icons = sidenav_icons(['Хиты продаж', 'Экспресс-кредит'])
    breadcrumb 'Хиты продаж', topsales_path
  end

  def tradein
    @used = UsedCar.where(used: 1).page(params[:page]).per(8)

    unless request.format.js?
      if Rails.env.rcar_dev? || Rails.env.rcar?
        @reviews = Review.order(created_at: :desc).limit(8)
      else
        @reviews = Review.order(created_at: :desc).limit(3)
      end

      @icons = sidenav_icons(['Заявка','Хиты продаж', 'Экспресс-кредит', 'Банки','Авто с пробегом','Отзывы'])
      breadcrumb 'Trade-in авто с пробегом', tradein_path
    end

    # @used = UsedCar.page(params[:page]).per(8)

  end

  def credit
    @icons = sidenav_icons(['Заявка','Полезная информация', 'Банки','Хиты продаж'])
    breadcrumb 'Кредит и рассрочка', credit_path
  end

  def credit_select
    if params[:brand].present?
      @res = Brand.find(params[:brand]).new_cars.where(hide: 0)
    end
    if params[:model].present?
      @res = NewCar.find(params[:model]).equipments
    end
  end

  def first_auto
    @special = UsedCar.special_cars(8)
    @icons = sidenav_icons(['Заявка','Полезная информация','Хиты продаж', 'Спецпредложения'])
    breadcrumb 'Кредит и рассрочка', credit_path, match: :exclusive
    breadcrumb 'Первый автомобиль', first_auto_path
  end

  def medical_auto
    @special = UsedCar.special_cars(8)
    @icons = sidenav_icons(['Заявка','Полезная информация','Хиты продаж', 'Спецпредложения'])
    breadcrumb 'Кредит и рассрочка', credit_path, match: :exclusive
    breadcrumb 'Для медработников', medical_auto_path
  end
  def family_auto
    @special = UsedCar.special_cars(8)
    @icons = sidenav_icons(['Заявка','Полезная информация','Хиты продаж', 'Спецпредложения'])
    breadcrumb 'Кредит и рассрочка', credit_path, match: :exclusive
    breadcrumb 'Семейный автомобиль', family_auto_path
  end

  def utilization
    @icons = sidenav_icons(['Заявка','Хиты продаж', 'Экспресс-кредит', 'Банки'])
    breadcrumb 'Утилизация', utilizaciya_path
  end

  def stock
    @icons = sidenav_icons(['Заявка','Хиты продаж', 'Экспресс-кредит', 'Банки'])
    breadcrumb 'Акции', stock_path
  end

  def contacts
    @icons = sidenav_icons(['Мы в соцсетях','Хиты продаж', 'Экспресс-кредит', 'Банки'])
    breadcrumb 'Контакты', contacts_path
  end

  def corporate
    breadcrumb 'Корпоративным клиентам', korporativnym_klientam_path
  end

  def policy
    breadcrumb 'Политика конфиденциальности', politika_konfidencialnosti_path
  end
  def akciy
    breadcrumb 'Политика конфиденциальности', pravila_provedeniya_akciy_path
  end

  def safe
    breadcrumb 'Безопасные автомобили', safecars_path
  end

  def womencars
    breadcrumb 'Авто для женщин', womencars_path
  end

  def cheap
    breadcrumb 'Дешевые автомобили', cheap_auto_path
  end

  def secure
    breadcrumb 'Надёжные автомобили', reliablecars_path
  end

  def show_common_modal
    if params[:common_modal_type]
      @common_modal_type = params[:common_modal_type]
    end
    render "show_common_modal"
  end

  def taxi
    breadcrumb 'Такси', taxi_path
    @taxi = UsedCar.where(taxi: 1).where(hide: 0)
  end

  def sell
    @used = UsedCar.where(used: 1).page(params[:page]).per(8)
    @reviews = Review.order(created_at: :desc).limit(12)


    breadcrumb 'Выкуп авто', sell_path
  end

  def service

    breadcrumb 'Сервисный центр', service_path
  end

end