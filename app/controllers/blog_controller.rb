class BlogController < ApplicationController
  caches_action :index,:show,:show_brand
  breadcrumb 'Блог', :blog_url, match: :exclusive

  before_action :redirect_from_region

  include NewCarsHelper

  def index
    @blog = Blog.all
  end

  def show
    @brand = Brand.find_by(url: params[:brand])
    @car = NewCar.find_by(url: params[:car_url])

    icons = []
    icons.push('Фотогалерея') if @car.images.present?

    # icons.push('Видео') if @car.video_link.present?

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
    @icons = sidenav_icons(icons)

    breadcrumb @brand.title, blog_brand_path(@brand),match: :exclusive
    breadcrumb @car.name, blog_car_path(@brand,@car),match: :exclusive
  end

  def show_brand
    @brand = Brand.find_by(url: params[:brand])

    breadcrumb @brand.title, blog_brand_path(@brand),match: :exclusive
  end


end
