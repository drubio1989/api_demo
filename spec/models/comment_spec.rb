require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'should be valid' do
    expect(build :comment).to be_valid
  end
end 
