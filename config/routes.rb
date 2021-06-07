class DoConstraint
  def initialize
    @numbers = [300000,350000,400000,450000,500000,550000,600000,650000,700000,800000,900000,1000000,1100000,1200000,1250000,1300000,1400000,1500000,1700000,2000000,2500000,3000000]
  end

  def matches?(request)
    @numbers.include?(request.params['number'].to_f)
  end
end

class DoTypeConstraint
  def initialize
    @numbers = [300000,350000,400000,450000,500000,550000,600000,650000,700000,800000,900000,1000000,1100000,1200000,1250000,1300000,1400000,1500000,1700000,2000000,2500000,3000000]
    @types = ['vehicle']
  end

  def matches?(request)
    @numbers.include?(request.params['number'].to_f)
    @types.include?(request.params['type'])
  end
end

class BrandConstraint
  def matches?(request)
    # Special rule for vaz-lada
    if request.params['brand'] === 'vaz-lada'
      true
    else
      b = Brand.where(url: request.params['brand'])
      b.present?
    end
  end
end

class UsedModelBrandConstraint
  def matches?(request)
    # used_car = false
    # Special rule for vaz-lada
    if request.params['brand'] === 'vaz-lada'
      used_car = UsedCar.where(brand:28).where(url: params['model'])
      used_car.present?
    else
      b = Brand.find_by(url: request.params['brand'])

      if b.present?
        used_car = UsedCar.where(brand:b.id).where(url: request.params['model']).where(used: 1)
        used_car.present?
      end
    end
  end
end

class UsedYearBrandConstraint
  def initialize
    @years = [2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018]
  end

  def matches?(request)
    # used_car = false
    # Special rule for vaz-lada
    if request.params['brand'] === 'vaz-lada'
      used_car = UsedCar.where(brand:28)
      used_car.present?
    else
      b = Brand.find_by(url: request.params['brand'])

      if b.present?
        used_car = UsedCar.where(brand:b.id).where(used: 1)
        used_car.present?
      end
    end

    @years.include?(request.params['year'].to_f)
  end
end

class UsedYearModelBrandConstraint
  def initialize
    @years = [2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018]
  end

  def matches?(request)
    # used_car = false
    # Special rule for vaz-lada
    if request.params['brand'] === 'vaz-lada'
      used_car = UsedCar.where(brand:28).where(url: params['model'])
      used_car.present?
    else
      b = Brand.find_by(url: request.params['brand'])

      if b.present?
        used_car = UsedCar.where(brand:b.id).where(url: request.params['model']).where(used: 1)
        used_car.present?
      end
    end
    @years.include?(request.params['year'].to_f)
  end
end

class DealModelBrandConstraint
  def matches?(request)
    if request.params['brand'] === 'vaz-lada'
      used_car = UsedCar.where(brand:28).where(url: params['model'])
      used_car.present?
    else
      b = Brand.find_by(url: request.params['brand'])
      if b.present?
        used_car = UsedCar.where(brand:b.id).where(url: request.params['model']).where(used: 0)
        used_car.present?
      end
    end
  end
end

class YearConstraint
  def initialize
    @years = [2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018]
  end

  def matches?(request)
    @years.include?(request.params['url'].to_f)
  end
end

class PriceConstraint
  def initialize
    @price = [150000,200000,250000,300000,350000,400000,450000,500000,550000,600000,700000,750000,800000,850000,900000,950000,1000000,1500000,2000000]
  end

  def matches?(request)
    @price.include?(request.params['url'].to_f)
  end
end

class NewCarConstraint
  def matches?(request)
    b = Brand.where(url: request.params['brand']).first
    if b.present?
      c = NewCar.where(url: request.params['car_url']).where(brand_id: b.id).where(hide: 0).first
      if c.present? && c.brand.url.downcase == request.params['brand']
        true
      else
        false
      end
    end
  end
end

class NewCarEquipmentConstraint
  def matches?(request)
    flag = false
    b = Brand.where(url: request.params['brand']).first
    if b.present?
      c = NewCar.where(url: request.params['car_url']).where(brand_id: b.id).where(hide: 0).first
      if c.present? && c.brand.url.downcase == request.params['brand']
        e = EquipmentDescription.where(new_car_id: c.id)
        e.each do |k|
          if k.name.parameterize == request.params['equip_url']
            return true
          end
        end
      end
    end
    false
  end
end

class NewCarEquipment_idConstraint
  def matches?(request)
    flag = false
    c = NewCar.where(url: request.params['car_url']).where(hide: 0).first
    if c.present?
      if c.brand.url.downcase == request.params['brand']
        ed = EquipmentDescription.where(new_car_id: c.id)
        ed.each do |k|
          if k.name.parameterize == request.params['equip_url']
            equips = k.equipments
            equips.each do |e|
              if e.id.to_s == request.params['equip_id'].to_s
                flag = true
                return flag
              end

            end
          else
            flag = false
          end
        end
      else
        flag = false
      end
    else
      flag = false
    end
    flag
  end
end

class NewCarColorConstraint
  def matches?(request)
    flag = false
    c = NewCar.where(url: request.params['car_url']).where(hide: 0).first
    if c.present?
      if c.brand.url.downcase == request.params['brand']
        if c.color_group.include?(request.params['color'])
          flag = true
        else
          flag = false
        end
      else
        flag = false
      end
    else
      flag = false
    end
    flag
  end
end

class NewCarCreditConstraint
  def matches?(request)
    b = Brand.where(url: request.params['brand']).first
    if b.present?
      c = NewCar.where(url: request.params['car_url']).where(brand_id: b.id).where(hide: 0).first
      if c.present? && c.brand.url.downcase == request.params['brand']
        true
      else
        false
      end
    end

  end
end

class NewCarTaxiConstraint
  def matches?(request)
    req = request.params['brand_car_url'].split("-", 2)
    c = NewCar.where(url: req[1]).where(hide: 0).first
    if c.present? && c.brand.url.downcase == req[0]
      request.params['brand'] = req[0]
      request.params['car_url'] = req[1]
      true
    else
      false
    end
  end
end

class NewCarCountryConstraint
  def initialize
    @countries = []
    countries = JSON.parse(File.read(Rails.root + 'db/assets/countries.json'))
    countries.each do |country|
      @countries.append(country['url'])
    end
  end

  def matches?(request)
    @countries.include?(request.params['url'])
  end
end

class NewCarTypeConstraint
  def initialize
    @types = []
    types = JSON.parse(File.read(Rails.root + 'db/assets/types.json'))
    types.each do |type|
      @types.append(type['url'])
    end
  end

  def matches?(request)
    @types.include?(request.params['url'])
  end
end

class UsedCarTransmissionConstraint
  def matches?(request)
    case request.params['url']
    when 'mkpp'
      transmission = 'MT'
    when 'akpp'
      transmission = 'AT'
    when 'variator'
      transmission = 'CVT'
    else
      return false
    end
    used_car = UsedCar.used_cars.where('`transmission` LIKE ?', '%' + transmission + '%')
    used_car.present?
  end
end

class BankConstraint
  def matches?(request)
    b = Bank.where(url: request.params['url']).where(has_page: true)
    b.present?
  end
end

class FinanceConstraint
  def matches?(request)
    b = Finance.where(url: request.params['url'])#.where(has_page: true)
    b.present?
  end
end

class ArticlesConstraint
  def matches?(request)
    b = Articles.find_by(url: request.params['url'])
    b.present?
  end
end


class NewsConstraint
  def matches?(request)
    n = Story.where(url: request.params['url'])
    n.present?
  end
end



Rails.application.routes.draw do

  get "/:region/sitemap.xml" => "sitemap#show", :format => "xml", :as => :sitemap

  post 'tickets/create'
  get 'tickets/orders',:defaults => { :format => :json }

  # XML feeds
  #    get '/feeds/yml-export' => 'feeds#yml_export',format: 'xml'
     get '/feeds/xml-auto-ru' => 'feeds#xml_auto_ru',format: 'xml'
  #    get '/feeds/xml-avito-ru' => 'feeds#xml_avito_ru',format: 'xml'
  #    get '/feeds/xml-cartraders-ru' => 'feeds#xml_cartraders_ru',format: 'xml'
      get '/feeds/csv-google.csv' => 'feeds#csv_google',format: 'csv'
      get '/feeds/xml-target' => 'feeds#xml_target',format: 'xml'
      get '/feeds/yandex-feed-export' => 'feeds#xml_yandex',format: 'xml'
      get '/feeds/vk-feed-export' => 'feeds#xml_vk',format: 'xml'

  # Static pages
  get '/tradein' => 'carso#tradein'
  get '/politika-konfidencialnosti' => 'carso#policy'
  get '/pravila-provedeniya-akciy' => 'carso#akciy'
  #get '/korporativnym-klientam' => 'carso#corporate'
  #get '/utilizaciya' => 'carso#utilization'
   get '/stock' => 'carso#stock'
  get '/contacts' => 'carso#contacts'
  #get '/topsales' => 'carso#topsales'
  get '/credit' => 'carso#credit'
  get '/banks/programma-pervyy-avtomobil' => 'carso#first_auto', as: 'first_auto'
  get '/banks/programma-semeynyy-avtomobil' => 'carso#family_auto', as: 'family_auto'
  get '/banks/programma-medical' => 'carso#medical_auto', as: 'medical_auto'
  get '/safecars' => 'carso#safe'
  get '/womencars' => 'carso#womencars'
  get '/cheap-auto' => 'carso#cheap'
  get '/reliablecars' => 'carso#secure'
  get '/taxi' => 'carso#taxi'
  get '/sell' => 'carso#sell'
  get '/service' => 'carso#service'
  post '/common_modal' =>  'carso#show_common_modal', as: 'common_modal'
  post '/credit' => 'carso#credit_select'
  post '/car_filter' => 'carso#show_filter', as: 'car_filter'

  # brands and new_cars
  resources :brands,:only => [:show], path: '',param: :brand,constraints: BrandConstraint.new
  # resources :new_cars,:only => [:show],param: :url,constraints: NewCarConstraint.new
  #
  get '/sell/:brand' => 'new_cars#used_sell', as: 'new_cars_sell'
  get '/:brand/:car_url'=>  'new_cars#show',constraints: NewCarConstraint.new, as: 'new_car'
  post '/new_car_filter/:brand/:car_url' => 'new_cars#show_filter' ,constraints: NewCarConstraint.new, as: 'new_car_filter'
  get '/:brand/:car_url/kit/:equip_url'=>  'new_cars#show_equipment',constraints: NewCarEquipmentConstraint.new, as: 'new_car_equipment'

  post '/:brand/:car_url/:equip_url'=>  'new_cars#row_description', as: :row_description

  get '/:brand/:car_url/:equip_url-:equip_id'=>  'new_cars#show_equipment_id',constraints: NewCarEquipment_idConstraint.new, as: 'new_car_equipment_id'

  get 'print/:brand/:car_url/:equip_url-:equip_id'=>  'new_cars#print_equipment_id', as: 'print_new_car_equipment_id', defaults: {format: 'pdf'}

  #get '/:brand/:car_url/:color'=>  'new_cars#show_color',constraints: NewCarColorConstraint.new, as: 'new_car_color'
  #get '/:brand/:car_url/tth'=>  'new_cars#show_tth',constraints: NewCarConstraint.new, as: 'new_car_tth'

     # get '/konfigurator' => 'new_cars#show_configurator', as: 'konfigurator'
     # get '/konfigurator/:brand' => 'new_cars#show_configurator', as: 'konfigurator_brand'
     # get '/konfigurator/:brand/:model' => 'new_cars#show_configurator', as: 'konfigurator_model'

      post '/konfigurator' => 'new_cars#show_configurator_options'

  post '/:brand/:id'=>  'new_cars#show_modal'
  post '/:brand/:car_url/configurator'=>  'new_cars#configurator',constraints: NewCarConstraint.new, as: 'new_car_configurator'

  get '/newauto' => 'brands#index'
  post '/filter' => 'brands#show_filter', as: 'brands_filter'

  #Credit brands and new_cars
 # get '/credit/:brand' => 'brands#show_credit',constraints: BrandConstraint.new, as: 'brand_credit'
 # get '/tradein/:brand' => 'brands#show_tradein',constraints: BrandConstraint.new, as: 'brand_tradein'
 # get '/taxi/:brand' => 'brands#show_taxi',constraints: BrandConstraint.new, as: 'brand_taxi'
 # get '/credit/:brand/:car_url'=>  'new_cars#show_credit',constraints: NewCarCreditConstraint.new, as: 'new_car_credit'
 # get '/tradein/:brand/:car_url'=>  'new_cars#show_tradein',constraints: NewCarCreditConstraint.new, as: 'new_car_tradein'
 # get '/taxi/:brand_car_url'=>  'new_cars#show_taxi',constraints: NewCarTaxiConstraint.new,as: 'new_car_taxi'

  # resources :brands,:only => [:show],param: :url, path: '/catalog',constraints: BrandConstraint.new do
  get '/:url' => 'new_cars#country', constraints: NewCarCountryConstraint.new, as: 'new_car_country'
  get '/:url' => 'new_cars#type', constraints: NewCarTypeConstraint.new, as: 'new_car_type'
  get '/:brand/:url' => 'new_cars#show_brand_type', constraints: NewCarTypeConstraint.new, as: 'brand_type'


  # banks
  resources :banks,:only => [:show],param: :url,path: '/banks',constraints: BankConstraint.new

  resources :stories,:only => [:show],param: :url,path: '/news',constraints: NewsConstraint.new

  # finance
  resources :finances,:only => [:show],param: :url,path: '',constraints: FinanceConstraint.new
  #resources :stories,:only => [:show],param: :url,path: '/news',constraints: NewsConstraint.new


  #articles
#  get '/article/:url' => 'articles#show', as: 'articles'#, constraints: ArticlesConstraint.new
 # get '/articles' => 'articles#index',  as: 'article'

#  get '/overview/:url' => 'overviews#show', as: 'overview'#, constraints: ArticlesConstraint.new
#  get '/blog' => 'overviews#index',  as: 'overviews'

#   get '/news' => 'stories#index'

  # get '/blog' => 'blog#index'
  # get '/blog/:brand' => 'blog#show_brand',constraints: BrandConstraint.new, as: 'blog_brand'
  # get '/blog/:brand/:car_url' => 'blog#show', as: 'blog_car'


  # used Cars
  #  get '/sprobegom' => 'used_cars#used'
  #  get '/brand/:brand' => 'used_cars#used_brand', constraints: BrandConstraint.new, as: 'used_brand'
  #  get '/brand/:brand/:model' => 'used_cars#used_brand_model', constraints: UsedModelBrandConstraint.new, as: 'used_brand_model'
  #  get '/brand/:brand/:year' => 'used_cars#used_brand_year', constraints: UsedYearBrandConstraint.new, as: 'used_brand_year'
  #  get '/brand/:brand/:model/:year' => 'used_cars#used_brand_model_year', constraints: UsedYearModelBrandConstraint.new, as: 'used_brand_model_year'
  #  get '/year/:url' => 'used_cars#used_year', constraints: YearConstraint.new, as: 'used_year'
  #  get '/price/:url' => 'used_cars#used_price', constraints: PriceConstraint.new, as: 'used_price'
  #  get '/sprobegom/:url' => 'used_cars#used_country', constraints: NewCarCountryConstraint.new, as: 'used_country'
  #  get '/sprobegom/:url' => 'used_cars#used_type', constraints: NewCarTypeConstraint.new, as: 'used_type'
  #  get '/sprobegom/:url' => 'used_cars#used_transmission', constraints: UsedCarTransmissionConstraint.new, as: 'used_transmission'
  #  post '/used/filter' => 'used_cars#show_filter_used', as: 'used_filter'


  # get '/deals' => 'used_cars#special'
  # get '/deals/:brand' => 'used_cars#special_brand',constraints: BrandConstraint.new, as: 'special_brand'
  # get '/deals/:brand/:model' => 'used_cars#special_model',constraints: DealModelBrandConstraint.new, as: 'special_model'
  post '/deals/filter' => 'used_cars#show_filter_special', as: 'specials_filter'

  # Reviews
  get '/reviews' => 'reviews#index'
  # get '/reviews/:brand' => 'reviews#brand',constraints: BrandConstraint.new, as: 'review_brand'
  # get '/reviews/:brand/:car_url'=>  'reviews#model',constraints: NewCarConstraint.new, as: 'review_model'
  get '/reviews/:id' => 'reviews#show', as: 'review_show'
  #get '/reviews/:brand/:model/:id' => 'reviews#show'




  post 'used_cars/show_modal/:id' => 'used_cars#show_modal'

  # Common tickets



   get '/do/:number', to: 'carso#do',constraints: DoConstraint.new, as: 'do'
   get '/:type/do/:number', to: 'carso#do_type',constraints: DoTypeConstraint.new, as: 'do_type'
  # get '/do/:number', to: 'carso#do'

  get '/robots.txt' => 'application#robots', defaults: {format: 'txt'}

  #Error
  get "/404", to: "errors#not_found", as: 'not_found', defaults: { format: 'html' }
  get "/422", to: "errors#unacceptable", as: 'unacceptable', defaults: { format: 'html' }
  get "/500", to: "errors#internal_error", as: 'internal_error', defaults: { format: 'html' }

  #webhook for calltouch
  post "/hooktouch", to: "hooktouch#receive"
  post "/hookamo", to: "hooktouch#hookamo"

  root 'carso#main'

  # match '*path', via: :all, to: "errors#not_found", as: 'not_found', defaults: { format: 'html' }

end