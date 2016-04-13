require 'rails_helper'

describe SessionsController, type: :controller do

  before :each do
    @user = create(:user)
  end
  it 'should authenticate user' do
    post :create, email: @user.email, password: @user.password

    expect(response).to redirect_to(tasks_path)
    expect(session[:user_id]).to eq(@user.id)
    expect(assigns[:current_user]).to eq(@user)
  end

  it 'should redirect back if wrong password' do
    post :create, email: @user.email, password: 'wrong password'
    expect(response).to redirect_to(new_sessions_path)
  end

  it 'should redirect back if wrong password' do
    post :create, email: 'wrong_email', password: 'wrong password'
    expect(response).to redirect_to(new_sessions_path)
  end
end
