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
          expect(response).to have_http_status(:unprocessable_entity)
        end

        #TODO: This needs to be implmented
        xit 'should return proper error json' do
          subject
          expect(json['errors']).to include({
            "status" => "422",
            "source" => { "pointer" => "/data/attributes/title" },
            "title" =>  "can't be blank",
            "detail" => "The title you provided cannot be blank."
          })
        end
      end

      context 'when success request sent' do
        let(:access_token) { create(:access_token) }
        before { request.headers['authorization'] = "Bearer #{access_token.token}" }

        let(:valid_attributes) do
          {
            "data" => {
              "attributes" => {
                "title" => "Hello World",
                "content" => "Hello world, my name is Daniel",
               "slug" => "hello-world"
              }
            }
          }
        end

        subject { post :create, params: valid_attributes }

        it 'should have 201 status' do 
          subject
          expect(response).to have_http_status(:created)
        end

        it 'should have proper json body' do 
          subject
          expect(json_data['attributes']).to include valid_attributes['data']['attributes']
        end 

        it 'should create the article' do
          expect{ subject }.to change{ Article.count }.by 1
        end
      end
    end
  end

  describe '#update' do
    let(:article) { create(:article) }
    subject { patch :update, params: { id: article.id } }

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

        subject { patch :update, params: invalid_attributes.merge(id: article.id) }

        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        #TODO: This needs to be implmented
        xit 'should return proper error json' do
          subject
          expect(json['errors']).to include({
            "status" => "422",
            "source" => { "pointer" => "/data/attributes/title" },
            "title" =>  "can't be blank",
            "detail" => "The title you provided cannot be blank."
          })
        end
      end

      context 'when success request sent' do
        let(:access_token) { create(:access_token) }
        before { request.headers['authorization'] = "Bearer #{access_token.token}" }

        let(:valid_attributes) do
          {
            "data" => {
              "attributes" => {
                "title" => "Hello World",
                "content" => "Hello world, my name is Daniel",
               "slug" => "hello-world"
              }
            }
          }
        end

        subject { patch :update, params: valid_attributes.merge(id: article.id, title: 'Hello World Two') }

        it 'should have 204 status' do 
          subject
          expect(response).to have_http_status(:no_content)
        end

        it 'should have proper json body' do 
          subject
          expect(json_data['attributes']).to include valid_attributes['data']['attributes']
        end 

        it 'should update the article' do
          subject
          expect(article.reload.title).to eq(valid_attributes['data']['attributes']['title'])
        end
      end
    end
  end
end
