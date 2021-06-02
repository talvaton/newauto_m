class FinancesController < ApplicationController
  caches_action :show

  def show
    @finance = Finance.find_by(url: params[:url])

    @brand = Brand.find_by(url: params[:brand])
    @brands = Brand.where(menu_show: true).order(:title)


    #@icons = sidenav_icons(['Хиты продаж','Спецпредложения'])
    #breadcrumb 'Кредит и рассрочка', credit_path, match: :exclusive
    breadcrumb @finance.name, finance_path(@finance.url), match: :exclusive
  end
end
