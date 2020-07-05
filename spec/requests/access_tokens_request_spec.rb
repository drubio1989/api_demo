require 'rails_helper'

RSpec.describe "AccessTokensController", type: :request do
  describe '#create' do
    context 'when invalid request' do
      let(:error) do
        {
          "status" => "401",
          "source" => { "pointer" => "/code" },
          "title" => "Authentication code is invalid",
          "detail" => "You must provide valid code to exchange for token"
        }
      end

      it 'should return 401 status code' do
        post login_path
        expect(response).to have_http_status(401)
      end

      it 'should return proper error body' do
        post login_path
        expect(json["errors"]).to eq(error)
      end
    end

    context 'successful requests' do
      xit 'returns 200 response' do
        post :create
      end
    end
  end
end
