require 'rails_helper'

describe TasksController, type: :controller do
  describe 'should redirect if not signed in' do
    %i(index).each do |action|
      it "from #{action}" do
        get action
        expect(response).to redirect_to new_sessions_path
      end
    end
  end
  describe 'should respond with tasks' do
    it 'if it is just user' do
      @user = create(:user)
      @task = create(:task, user: @user)
      sign_in(@user)
      get :index
      expect(assigns(:tasks)).to eq([@task])
    end
  end
end
