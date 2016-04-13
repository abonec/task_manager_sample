require 'rails_helper'

describe TasksController, type: :controller do
  describe 'should redirect if not signed in' do
    {index: {method: :get}, edit: {method: :get, params: {id: 1}}}.each do |action, options|
      it "from #{action}" do
        send(options[:method], action, options[:params])
        expect(response).to redirect_to new_sessions_path
      end
    end
  end
  describe 'should works with tasks' do
    describe 'as normal user' do
      before :each do
        @user = create(:user)
        sign_in @user
      end

      it 'and show all own tasks' do
        @task1 = create(:task, user: @user)
        @task2 = create(:task, user: @user)
        get :index
        expect(assigns(:tasks).sort).to eq([@task1, @task2].sort)
      end

      %i(show edit).each do |action|
        it "and #{action} task" do
          @task = create(:task, user: @user)
          get action, id: @task.id
          expect(assigns(:task)).to eq(@task)
        end

        it "and redirect to tasks if user don't have permission for #{action} task" do
          @task = create(:task)
          get action, id: @task.id
          expect(@task.user).not_to eq(@user)
          expect(response).to redirect_to tasks_path
        end
      end
    end
  end

end
