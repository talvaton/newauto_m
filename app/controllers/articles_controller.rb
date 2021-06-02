class ArticlesController < ApplicationController
  caches_action :show

  def index
    @articles = Articles.find_by(url: params[:url])
    @articles = Articles.order(created_at: :desc)
    #@icons = sidenav_icons(['Хиты продаж','Спецпредложения'])
    #breadcrumb 'Кредит и рассрочка', credit_path, match: :exclusive
    #breadcrumb @finance.name, finance_path(@finance.url), match: :exclusive
  end

  def show
    @articles = Articles.find_by(url: params[:url])

    breadcrumb 'articles', '/articles', match: :exclusive
  end

end
