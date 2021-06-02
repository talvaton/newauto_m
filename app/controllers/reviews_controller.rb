class ReviewsController < ApplicationController
  caches_action :index,:model,:brand,unless: -> { request.format.js? }

  def index
    @reviews = Review.order(created_at: :desc).page(params[:page]).per(21)

    breadcrumb 'Отзывы', reviews_path
  end

  def show
    @reviews = Review.find(params[:id])
   # @brand = Brand.find_by(url: params[:brand])

    #@reviews = @brand.reviews

    unless @reviews.present?
      render status: 404
    end
    breadcrumb 'Отзывы', reviews_path,match: :exclusive
    breadcrumb @reviews.name, review_show_path(@reviews)
  end

  def brand
    # if params[:brand]
    @brand = Brand.find_by(url: params[:brand])
    # @newcars = NewCar.where(brand_id: @brand)

    @reviews = @brand.reviews

    unless @reviews.present?
      render status: 404
    end

    # if Review.where(new_car_id: @newcars).first
    #     @reviews = Review.where(new_car_id: @newcars).page(params[:page]).per(20)
    #     render "salon/reviews/brand"
    # else
    #       render "salon/errors/not_found", status: 404
    # end

    breadcrumb 'Отзывы', reviews_path,match: :exclusive
    breadcrumb @brand.title, review_brand_path(@brand)

  end

  def model
    @car = NewCar.where(url: params[:car_url]).where(hide: 0).first
    @reviews_car = Review.order(created_at: :desc).page(params[:page]).per(21)

    @reviews = @car.reviews

    unless @reviews.present?
      render status: 404
    end

    breadcrumb 'Отзывы', reviews_path,match: :exclusive
    breadcrumb @car.brand.title, review_brand_path(@car.brand),match: :exclusive
    breadcrumb @car.name, review_model_path(@car.brand.url,@car.url)
  end

end
