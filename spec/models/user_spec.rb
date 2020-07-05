require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should be valid' do
    user = build(:article)
    expect(user).to be_valid
  end

  it 'should not be valid' do
    user = build(:user, login: '')
    expect(user).not_to be_valid
  end

  it 'should not be valid' do
    user = create(:user, login: 'drubio')

    user_two = build(:user, login: 'drubio')
    expect(user_two).not_to be_valid
  end

  it 'should not be valid' do
    user = build(:user, provider: '')
    expect(user).not_to be_valid
  end
end
