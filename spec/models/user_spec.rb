require 'rails_helper'

describe User, type: :model do
  it { should have_many(:tasks).dependent(:destroy) }
  it { should validate_uniqueness_of(:email) }

  describe 'auth' do
    it 'should register' do
      @user = User.register! 'example@gmail.com', 'secret'
      expect(@user.persisted?).to be_truthy
    end

    it 'should authenticate' do
      email = 'example@gmail.com'
      password = 'secret'
      @user = User.register! email, password
      @authenticated_user = User.authenticate email, password

      expect(@user).to eq @authenticated_user

    end
  end
end
