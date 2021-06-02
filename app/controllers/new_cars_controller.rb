class NewCarsController < ApplicationController

  # before_action :cookietime
  caches_action :show,:show_credit,:show_tradein,:show_taxi,:show_equipment,:show_color,:show_tth,:country,:type

  before_action :redirect_from_region, only:[:show_tth,:show_configurator,:show_configurator_options]


  include CreditHelper


  # include Math

  # def region_name
  #   @regions = Region.where.not(id: [32,42,43,57])
  #   @current_region = Region.find_by(name: request.subdomains.first)
  #   unless @current_region.present?
  #     @current_region = Region.find(57)
  #   end
  # end

  def get_filters_initial
    @equipments = Equipment.joins(:equipment_description).where(hide:0)
                      .where('`equipment_descriptions`.`new_car_id` = ?', @car.id)

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
    @car.color_options.each_with_index do |c, ind|

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

  def show
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:car_url]).where(brand_id: @brand.id).where(hide: 0).first

    # @used = UsedCar.used_cars.where(brand_id: @brand).where(name: @car.name).limit(16)
    # @special = UsedCar.special_cars.where(brand_id: @brand).where(name: @car.name).limit(16)

    get_filters_initial

    icons = []

    icons.push('Комплектации и цены') unless @car.archive?

    if @car.description.present?
      icons.push('Описание') if @car.description['text_lower'].present?
    end
    icons.push('Фотогалерея') if @car.images.present?
    if @car.video_link.present?
      vidlink = "https://img.youtube.com/vi/#{@car.video_link.gsub(/\?.+/, '')}/sddefault.jpg"
      unless NewCarsHelper.working_url?(vidlink)
        vidlink = "https://img.youtube.com/vi/#{@car.video_link.gsub(/\?.+/, '')}/hqdefault.jpg"
      end
      if NewCarsHelper.working_url?(vidlink)
        icons.push('Видео')
      end
    end
    icons.push('Модельный ряд')
    icons.push('Аналоги')




    #
    # vidurl = "https://img.youtube.com/vi/#{@car.video_link.gsub(/\?.+/, '')}/sddefault.jpg"
    # unless working_url?(vidurl)
    #   vidurl = "https://img.youtube.com/vi/#{@car.video_link.gsub(/\?.+/, '')}/hqdefault.jpg"
    # end

    # cookietime

    # @car.color_options.each do |color|
    #   identify_color(color)
    # end
    @prev_path = set_prev_path

    @icons = sidenav_icons(icons)

    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb @brand.title, brand_path(@brand),match: :exclusive
    breadcrumb @car.name, new_car_path(@car.brand.url,@car.url)
  end

  def show_credit
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:car_url]).where(hide: 0).first

    # @used = UsedCar.used_cars.where(brand_id: @brand).where(name: @car.name).limit(16)
    # @special = UsedCar.special_cars.where(brand_id: @brand).where(name: @car.name).limit(16)

    get_filters_initial

    icons = []
    icons.push('Комплектации и цены') unless @car.archive?
    icons.push('Фотогалерея') if @car.images.present?
    if @car.video_link.present?
      vidlink = "https://img.youtube.com/vi/#{@car.video_link.gsub(/\?.+/, '')}/sddefault.jpg"
      unless NewCarsHelper.working_url?(vidlink)
        vidlink = "https://img.youtube.com/vi/#{@car.video_link.gsub(/\?.+/, '')}/hqdefault.jpg"
      end
      if NewCarsHelper.working_url?(vidlink)
        icons.push('Видео')
      end
    end
    icons.push('Модельный ряд')
    icons.push('Аналоги')

    @prev_path= set_prev_path

    @icons = sidenav_icons(icons)
    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb 'Кредит', credit_path, match: :exclusive
    breadcrumb @brand.title, brand_credit_path(@brand),match: :exclusive
    breadcrumb @car.name, new_car_credit_path(@car.brand.url,@car.url)
  end


  def show_tradein
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:car_url]).where(hide: 0).first

    # @used = UsedCar.used_cars.where(brand_id: @brand).where(name: @car.name).limit(16)
    # @special = UsedCar.special_cars.where(brand_id: @brand).where(name: @car.name).limit(16)

    get_filters_initial

    icons = []
    icons.push('Комплектации и цены') unless @car.archive?
    icons.push('Фотогалерея') if @car.images.present?
    if @car.video_link.present?
      vidlink = "https://img.youtube.com/vi/#{@car.video_link.gsub(/\?.+/, '')}/sddefault.jpg"
      unless NewCarsHelper.working_url?(vidlink)
        vidlink = "https://img.youtube.com/vi/#{@car.video_link.gsub(/\?.+/, '')}/hqdefault.jpg"
      end
      if NewCarsHelper.working_url?(vidlink)
        icons.push('Видео')
      end
    end
    icons.push('Модельный ряд')
    icons.push('Аналоги')

    @prev_path= set_prev_path

    @icons = sidenav_icons(icons)
    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb 'Трейд ин', tradein_path, match: :exclusive
    breadcrumb @brand.title, brand_tradein_path(@brand),match: :exclusive
    breadcrumb @car.name, new_car_tradein_path(@car.brand.url,@car.url)
  end


  def show_taxi
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:car_url]).where(hide: 0).first

    #get_filters_initial

    #@prev_path= set_prev_path

    breadcrumb 'Такси', taxi_path, match: :exclusive
  end



  def show_equipment
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:car_url]).where(brand_id: @brand.id).where(hide: 0).first
    # @equip = EquipmentDescription.where(new_car_id: @car.id).where(name: params[:equip_url])
    # puts 'test'
    # puts @equip.name
    # @equips.each do |equip|
    #   if equip.name.parameterize == params[:equip_url]
    #     @equip = equip
    #   end
    # end
    @car.equipment_descriptions.each do |e|
      puts "#{e.name}"
      if e.name.parameterize == params[:equip_url]
        @equip = e
      end
    end

    icons = []
    icons.push('Комплектации и цены') unless @car.archive?
    icons.push('Описание')
    icons.push('Трейд-ин')
    icons.push('Модельный ряд')
    icons.push('Аналоги')

    @prev_path = set_prev_path

    @icons =  sidenav_icons(icons)
    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb @brand.title, brand_path(@brand),match: :exclusive
    breadcrumb @car.name, new_car_path(@car.brand.url,@car.url),match: :exclusive
    breadcrumb @equip.name, new_car_equipment_path(@car.brand.url,@car.url, @equip.name.parameterize)
  end


  def show_equipment_id
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:car_url]).where(hide: 0).first
    @equipment = Equipment.find(params[:equip_id])
    @car.equipment_descriptions.each do |e|
      if e.name.parameterize == params[:equip_url]
        @equip = e
      end
    end
    @prev_path = set_prev_path
    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb @brand.title, brand_path(@brand),match: :exclusive
    breadcrumb @car.name, new_car_path(@car.brand.url,@car.url),match: :exclusive
  end


  def show_tth
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:car_url]).where(hide: 0).first

    icons = []
    icons.push('Трейд-ин')
    icons.push('Модельный ряд')
    icons.push('Аналоги')

    @prev_path = set_prev_path

    @icons =  sidenav_icons(icons)
    breadcrumb "Каталог новых авто#{" в " + @current_region.sklon3 unless @current_region.id === 57}", :newauto_path, match: :exclusive
    breadcrumb @brand.title, brand_path(@brand),match: :exclusive
    breadcrumb @car.name, new_car_path(@car.brand.url,@car.url),match: :exclusive
    breadcrumb "Тех. характеристики", new_car_tth_path
  end

  def show_color
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:car_url]).where(hide: 0).first

    @colors_to_show = []
    @car.color_options.each_with_index do |c,index|
      if c['color_type'] == params[:color]
        c['index'] = index
        @colors_to_show.push(c)
      end
    end

    @t_color = 'Без цвета'
    @t_color2 = ''
    case params[:color]
    when 'red'
      @t_color = 'Красный'
      @t_color2 = 'Красного'
    when 'blue'
      @t_color = 'Синий'
      @t_color2 = 'Синего'
    when 'green'
      @t_color = 'Зеленый'
      @t_color2 = 'Зеленого'
    when 'yellow'
      @t_color = 'Желтый'
      @t_color2 = 'Желтого'
    when 'violet'
      @t_color = 'Фиолетовый'
      @t_color2 = 'Фиолетового'
    when 'lightblue'
      @t_color = 'Голубой'
      @t_color2 = 'Голубого'
    when 'orange'
      @t_color = 'Оранжевый'
      @t_color2 = 'Оранжевого'
    when 'brown'
      @t_color = 'Коричневый'
      @t_color2 = 'Коричневого'
    when 'black'
      @t_color = 'Черный'
      @t_color2 = 'Черного'
    when 'gray'
      @t_color = 'Серый'
      @t_color2 = 'Серого'
    when 'white'
      @t_color = 'Белый'
      @t_color2 = 'Белого'
    end

    icons = []
    icons.push('Комплектации и цены') unless @car.archive?
    icons.push('Трейд-ин')
    icons.push('Модельный ряд')
    icons.push('Аналоги')

    @prev_path = set_prev_path

    @icons =  sidenav_icons(icons)

    breadcrumb @brand.title, brand_path(@brand),match: :exclusive
    breadcrumb @car.name, new_car_path(@car.brand.url,@car.url),match: :exclusive
    breadcrumb @t_color, new_car_color_path(@car.brand.url,@car.url, params[:color])
  end

  def show_filter
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:car_url]).where(hide: 0).first

    @res = Equipment.where(hide: 0).joins(:equipment_description).joins(:specification)
                .where('`equipment_descriptions`.`new_car_id` = ?', @car.id)

    @res = @res.where('`equipment_descriptions`.`name` = ?', params[:compl]) if params[:compl].present?
    @res = @res.where('`specifications`.`transmission` = ?', params[:transmission]) if params[:transmission].present?
    @res = @res.where('ROUND(`specifications`.`volume`, -2) / 1000.0 = ?', params[:volume]) if params[:volume].present?
    @res = @res.where('`specifications`.`drive` = ?', params[:drive]) if params[:drive].present?

  end

  def configurator

    @car = NewCar.where(url: params[:car_url]).where(hide: 0).first
    if params[:param] == 'compl'
      @engines = Equipment.joins(:equipment_description).where('equipment_descriptions.name = ?', params[:compl]).where('equipment_descriptions.new_car_id = ?', @car.id)
      # puts @engines
      render 'configurator_compl'
    end
    if params[:param] == 'tech'
      @spec = Specification.find(params[:spec])
      render 'configurator_engine'
    end
  end

  def show_configurator
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.where(url: params[:model]).where(hide: 0).first

    # breadcrumb @brand.title, brand_path(@brand),match: :exclusive
    # breadcrumb @car.name, new_car_path(@car.brand.url,@car.url)
    breadcrumb 'Конфигуратор', konfigurator_path
  end

  def show_configurator_options
    if params[:type] == 'brand'
      @brand = Brand.find(params[:brand])
      @models = NewCar.where(brand_id: @brand.id).where(hide: 0).where(archive: 0)

      render 'show_configurator_brand.js'
    end
    if params[:type] == 'model'
      @model = NewCar.find(params[:model])

      render 'show_configurator_model.js'
    end
    if params[:type] == 'complectation'
      @model = NewCar.find(params[:model])
      @specifications = Equipment.select('`equipment`.`id` AS e_id,`equipment`.`price`,`specifications`.*').joins(:equipment_description).joins(:specification).where('`equipment_descriptions`.`new_car_id` = ?',params[:model]).where('`equipment_descriptions`.`name` = ?',params[:mod])

      render 'show_configurator_modification.js'
    end
  end

  def country
    @country = params[:url]
    countries = JSON.parse(File.read(Rails.root + 'db/assets/countries.json'))
    countries.each do |country|
      if country['url'] == @country
        @title = country['title']
        @text = country['description']
        @brands_country = country['brands'].split(',')
      end
    end
    breadcrumb @title, new_car_country_path(@country)
  end

  def type
    @type = params[:url]
    types = JSON.parse(File.read(Rails.root + 'db/assets/types.json'))
    types.each do |type|
      if type['url'] == @type
        @title = type['title']
        @text = type['description']
        @name = type['name']
        @cars = NewCar.where("car_type LIKE ?", '%'+ @name +'%').where(hide: 0)
      end
    end
    breadcrumb @title, new_car_type_path(@type)
  end

  def show_brand_type
    @brand = Brand.find_by(url: params[:brand])
    @type = params[:url]
    types = JSON.parse(File.read(Rails.root + 'db/assets/types.json'))
    types.each do |type|
      if type['url'] == @type
        @title = type['title']
        @text = type['description']
        @name = type['name']
        @cars = NewCar.where("car_type LIKE ?", '%'+ @name +'%').where(brand: @brand).where(hide: 0)
      end
    end
    breadcrumb @brand.title, brand_path(@brand),match: :exclusive
    breadcrumb @title, brand_type_path(@brand,@type)
  end

  def show_modal
    @car = NewCar.find(params[:id])
    if params[:eq_id].present?
      @equip = Equipment.find(params[:eq_id])
    end
    # @block = params[:block]
    case params[:modal]
    when 'car-credit-modal'
      render "show_modal_credit"
    when 'car-bron-modal'
      render "show_modal_bron"
    when 'car-details-modal'
      render "show_modal_details"
    when 'fix-popup-modal'
      render "show_modal_fix_popup"
    when 'car-testdrive-modal'
      render "show_modal_testdrive"
    when 'car-tradein-modal'
      render "show_modal_tradein"
    when 'car-features-modal'
      render "show_modal_features"
    when 'car-request-modal'
      render "show_modal_request"
    when 'car-vcredit-modal'
      render "show_modal_vcredit"
    when 'car-colors-modal'
      render "show_modal_colors"
    when 'car-equipments-modal'
      render "show_modal_equipments"
    when 'car-obmen-modal'
      render "show_modal_obmen"
    when 'profit__dealer'
      render "show_modal_profit_dealer"
    when 'profit__cash'
      render "show_modal_profit_cash"
    when 'profit__fee'
      render "show_modal_profit_fee"
    when 'profit__first'
      render "show_modal_profit_first"
    when 'profit__credit'
      render "show_modal_profit_credit"
    when 'profit__tradein'
      render "show_modal_profit_tradein"
    when 'profit__family'
      render "show_modal_profit_family"
    when 'profit__util'
      render "show_modal_profit_util"
    end
  end

  def print_equipment_id
    @e = Equipment.find(params['equip_id'])
    @car = NewCar.find_by url: params['car_url']
    @real_discount = @car.discount_count(@e) + @region_discount
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "test"   # Excluding ".pdf" extension.
      end
    end
  end

  def row_description
    @brand = Brand.find_by(url: params['brand'])
    @car = NewCar.where(url: params['car_url']).where(brand_id: @brand.id).first
    @equipment = Equipment.find(params['equip_url'])
  end

  # def cookietime
  #   if cookies[:cookietime].present?
  #     cookies[:cookietime] = 2
  #   else
  #     cookies[:cookietime] = 1
  #   end
  # end

  private
  def identify_color(color)
    c = Paleta::Color.new(:hex, color['color'][1..6])

    palete = []
    # Красный
    palete.push(Paleta::Color.new(:hex, 'FF0000'))
    # Синий
    palete.push(Paleta::Color.new(:hex, '0000FF'))
    # Зелёный
    palete.push(Paleta::Color.new(:hex, '00FF00'))
    # Желтый
    palete.push(Paleta::Color.new(:hex, 'FFFF00'))
    # Фиолетовый
    palete.push(Paleta::Color.new(:hex, 'f5baf5'))
    # Голубой
    palete.push(Paleta::Color.new(:hex, '00FFFF'))
    # orange
    palete.push(Paleta::Color.new(:hex, 'C04914'))
    # brown
    palete.push(Paleta::Color.new(:hex, '8B4513'))
    # red2
    palete.push(Paleta::Color.new(:hex, 'FF0004'))

    # puts "color1: #{color['color'][1..2].to_i(16)} color2: #{color['color'][3..4].to_i(16)} color3: #{color['color'][5..6].to_i(16)} colorname: #{color['colorname']}"
    colors = []

    colors.push(color['color'][1..2].to_i(16))
    colors.push(color['color'][3..4].to_i(16))
    colors.push(color['color'][5..6].to_i(16))

    diff = (colors.max - colors.min).abs

    if diff >= 20
      sim = []
      palete.each do |p|
        c_diff = distance([c.hue,c.lightness,c.red,c.green,c.blue],[p.hue,p.lightness,p.red,p.green,p.blue])
        sim.push c_diff
      end
      min_index = sim.each_with_index.min

      case min_index[1]
      when 0
        puts 'red'
      when 1
        puts 'blue'
      when 2
        puts 'green'
      when 3
        puts 'yellow'
      when 4
        puts 'violet'
      when 5
        puts 'lightblue'
      when 6
        puts 'orange'
      when 7
        puts 'brown'
      when 8
        puts 'red2'
      else
        puts 'no color'
      end
    else
      middle = colors.sum / 3
      case middle
      when 1..49
        puts 'black'
      when 50..160
        puts 'gray'
      when 161..255
        puts 'white'
      else
        puts 'no color'
      end
    end
  end

  def distance(a, b)
    unless (a.is_a?(Hash) && b.is_a?(Hash) && a.keys == b.keys) || (a.is_a?(Array) && b.is_a?(Array) && a.size == b.size)
      raise ArgumentError, "Arguments must be Hashes with identical keys or Arrays of the same size"
    end
    sum = 0
    a.keys.each { |k| sum += (a[k] - b[k]) ** 2 } if a.is_a?(Hash)
    a.each_with_index { |v, i| sum += (a[i] - b[i]) ** 2 } if a.is_a?(Array)
    Math.sqrt(sum)
  end

end
