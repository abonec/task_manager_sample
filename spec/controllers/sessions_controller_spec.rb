require 'rails_helper'

describe SessionsController, type: :controller do

  before :each do
    @user = create(:user)
  end
  it 'should authenticate user' do
    post :create, sessions: { email: @user.email, password: @user.password }

    expect(response).to redirect_to(tasks_path)
    expect(session[:user_id]).to eq(@user.id)
    expect(assigns[:current_user]).to eq(@user)
  end

  it 'should redirect back if wrong password' do
    post :create, sessions: { email: @user.email, password: 'wrong password' }
    expect(response).to redirect_to(new_sessions_path)
  end

  it 'should redirect back if wrong password' do
    post :create, sessions: { email: 'wrong_email', password: 'wrong password' }
    expect(response).to redirect_to(new_sessions_path)
    expect(flash[:error]).to eq(I18n.t('sessions.user_not_found'))
  end
  it 'should redirect back if blank credentials' do
    post :create, sessions: { email: '', password: '' }
    expect(response).to redirect_to(new_sessions_path)
    expect(flash[:error]).to eq(I18n.t('sessions.please_enter_credentials'))
  end
end
