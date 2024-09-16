# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    # Happy scenario
    it 'is valid with valid attributes' do
      user = User.new(name: 'John Doe')
      expect(user.valid?).to be true
    end
    # Unhappy scenario
    it 'is invalid without a name' do
      user = User.new(name: nil)
      expect(user.valid?).to be false
    end
  end
end
