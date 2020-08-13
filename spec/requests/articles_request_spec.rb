require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe '#index' do
    subject { get :index }

    it 'returns ok response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'returns proper json' do
      create_list(:article, 10)
      subject
      expect(json_data.length).to eq(10)
    end

    it 'has correct keys' do
      create(:article)
      subject
      expect(json_data[0].has_key? "id").to  be true
      expect(json_data[0].has_key? "type").to be true
      expect(json_data[0]["attributes"].keys).to include( "title", "content", "slug")
    end

    it 'returns article by most recent' do
      new_article = create(:article)
      old_article = create(:article, created_at: DateTime.now - 1.days)
      subject
      expect(json_data.first["id"]).to eq(new_article.id.to_s)
      expect(json_data.last["id"]).to eq(old_article.id.to_s)
    end
  end

  describe '#create' do
    subject { post :create }

    context 'when no code provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do  
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }
      context 'when invalid parameters provided' do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: '',
                content: ''
              }
            }
          }
        end

        subject { post :create, params: invalid_attributes }

        it 'should return 422 status code' do
          subject
          byebug
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return proper error json' do
          subject
          expect(json['errors']).to include({
            "status" => "422",
            "source" => { "pointer" => "/data/attributes/title" },
            "title" =>  "can't be blank",
            "detail" => "The title you provided cannot be blank."
          })
        end
      end
    end
  end
end
