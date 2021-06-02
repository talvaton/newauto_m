require 'rails_helper'

RSpec.describe BanksController, type: :controller do

  context 'Bank has page' do
    let(:bank_with_page) { FactoryBot.create(:bank,:has_page) }
    let(:bank_no_page) { FactoryBot.create(:bank,:no_page) }

    it 'Return 200 for bank page' do
      get :show, params:{url: bank_with_page.url}
      expect(response).to have_http_status(200)
    end

    it 'Return 404 for bank with no page' do
      visit bank_no_page.url
      expect(page.status_code).to eq(404)
    end

    #Description
  end
end
