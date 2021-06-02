class StoriesController < ApplicationController
  caches_action :index,unless: -> { request.format.js? }
  caches_action :show

  breadcrumb 'Новости', :news_path, match: :exclusive

  def index
    @news = Story.order("created_at DESC").page(params[:page]).per(24)
  end

  def show
    @news_item = Story.find_by(url: params[:url])
    @brand = Brand.find_by(id: @news_item.brand_id)

    @car = NewCar.find_by(url: params[:car_url])

    breadcrumb @news_item.name, :news_path
  end
end