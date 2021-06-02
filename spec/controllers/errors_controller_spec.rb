require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do
  context 'Error pages availability' do
    it 'Return 404 for not found page' do   #
      get :not_found
      expect(response).to have_http_status(404)
    end

    it 'Return 422 for unacceptable page' do   #
      get :unacceptable
      expect(response).to have_http_status(422)
    end

    it 'Return 500 for internal error page' do   #
      get :internal_error
      expect(response).to have_http_status(500)
    end
  end
end
