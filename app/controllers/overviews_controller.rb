class OverviewsController < ApplicationController
  caches_action :show

  def index
    @overviews = Overviews.find_by(url: params[:url])
    @overviews = Overviews.order(created_at: :desc)
    #@icons = sidenav_icons(['Хиты продаж','Спецпредложения'])
    #breadcrumb 'Кредит и рассрочка', credit_path, match: :exclusive
    #breadcrumb @finance.name, finance_path(@finance.url), match: :exclusive
  end

  def show
    @overviews = Overviews.find_by(url: params[:url])

    breadcrumb 'overview', '/blog', match: :exclusive
  end

end
