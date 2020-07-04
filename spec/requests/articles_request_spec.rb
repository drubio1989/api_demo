require 'rails_helper'

RSpec.describe "ArticlesController", type: :request do
  describe '#index' do
    subject { get articles_path }

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
end
