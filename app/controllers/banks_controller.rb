class BanksController < ApplicationController
  caches_action :show

  def show
    @bank = Bank.find_by(url: params[:url])
    @icons = sidenav_icons(['Хиты продаж','Спецпредложения'])
    breadcrumb 'Кредит и рассрочка', credit_path, match: :exclusive
    breadcrumb @bank.name, bank_path(@bank.url), match: :exclusive
  end
end
