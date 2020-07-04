require 'rails_helper'

RSpec.describe Article, type: :model do
  it 'should be valid' do
    article = build(:article)
    expect(article).to be_valid
  end

  it 'validates title' do
    article = build(:article, title: '')
    expect(article).not_to be_valid
    expect(article.errors.messages[:title]).to include("can't be blank")
  end

  it 'validates content' do
    article = build(:article, content: '')
    expect(article).not_to be_valid
    expect(article.errors.messages[:content]).to include("can't be blank")
  end

  it 'validates slug' do
    article = build(:article, slug: '')
    expect(article).not_to be_valid
  end
end
