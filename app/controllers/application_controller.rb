class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  before_action :set_view_path,:load_regions,:load_brands,:load_hit,:mobile_detect

  before_action do
    if Rails.env.salon_dev? || Rails.env.rcar_dev?
      Rack::MiniProfiler.authorize_request
    end
  end

  layout 'carso'

    #layout 'saloncentr' if (Rails.env.saloncentr? || Rails.env.salon_dev?)
    #layout 'saloncentr2' if (Rails.env.saloncentr? || Rails.env.salon_dev?)
  #layout 'rcar' if (Rails.env.rcar? || Rails.env.rcar_dev?)
  # include SessionsHelper

  breadcrumb 'Авимоторс', :root_path

  #def extract_region_from_subdomain 
    #parsed_locale = request.subdomains.first

#    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  #end

  def load_regions
    @region_discount = 0
    @regions = Region.where.not(id: [32,42,43,57])
    @current_region = Region.find_by(name: request.subdomains.first)
    unless @current_region.present?
      @current_region = Region.find(57)
    end
    unless @current_region.id == 57
      @region_discount = 10000
    end
  end

  def load_brands
    # allowed_ids = [4,10,13,14,15,16,18,21,22,23,25,26,27,28,32,36]
    @brands = Brand.where(id: ALLOWED_BRANDS).where(menu_show: true).order(:title)
  end

  def load_hit
    # @hit = NewCar.where(special_options: 'Хит-продаж').limit(12)
    @hit = NewCar.where("`new_cars`.`special_options` LIKE ?",'%Хит-продаж%').limit(12)
  end

  def robots
    robots = "/robots/robots"
    render robots, layout: false, content_type: 'text/plain'
  end

  def sidenav_icons(icons_list)
    result = []
    sideicons = JSON.parse(File.read(Rails.root + 'app/assets/javascripts/carso/sidenav.json'))
    icons_list.each do |icon|
      sideicons.each do |icon_json|
        if icon == icon_json['name']
          result.push icon_json
        end
      end
    end
    # sideicons.each do |icon|
    #   if icons_list.include? icon['name']
    #     result.push icon
    #   end
    # end
    result
  end

  def mobile_detect
    user_agent = request.user_agent
    #puts user_agent
    client = DeviceDetector.new(user_agent)
    if client.device_type == 'smartphone'
      @md = true
    else
      @md = false
    end
    #puts @md
  end

  def set_prev_path
    current_path = request.path.split('/')
    current_path.pop
    current_path.join('/')
  end

  private


  def redirect_from_region
    action = 'index'
    if controller_name == 'new_cars'
      action = action_name
    else
      if params[:brand].present?
        action = 'show_brand'
      end
      if params[:car_url].present?
        action = 'show'
      end
    end

    unless @current_region.id == 57
      redirect_to subdomain: '', :controller => controller_name, :action => action
    end
  end


  def set_view_path
    folder = 'carso'
    #if Rails.env.saloncentr? || Rails.env.salon_dev?
      #folder = 'salon'
    #else
    #  folder = 'rcar'
    #end
    prepend_view_path "#{Rails.root}/app/views/#{folder}"
  end



  #   when "mysite.com"
  #     site = "my_site" # root view path will be app/views/my_site
  #   when "myothersite.com"
  #     site = "my_other_site" # root view path will be app/views/my_other_site
  #   else
  #     site = "default_site" # root view path will be app/views/default_site
  #   end
  #   prepend_view_path "#{Rails.root}/app/views/#{site}"

end