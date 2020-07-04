require 'rails_helper'

describe 'articles routes' do
  it 'shoute route to index' do
    expect(get '/articles').to route_to 'articles#index'
  end
end
