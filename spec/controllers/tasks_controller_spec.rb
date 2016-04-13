require 'rails_helper'

describe TasksController, type: :controller do
  describe 'should redirect if not signed in' do
    {
        index: {method: :get},
        edit: {method: :get, params: {id: 1}},
        show: {method: :get, params: {id: 1}},
        update: {method: :put, params: {id: 1}},
    }.each do |action, options|
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

      let (:task_attributes) {
        { name: 'task_name', description: 'description', }
      }
      it 'and create task' do
        expect {
          post :create, task: task_attributes
        }.to change(Task, :count).to 1

        @task = assigns(:task)
        expect(@task.name).to eq(task_attributes[:name])
        expect(@task.description).to eq(task_attributes[:description])
        expect(@task).to be_persisted
        expect(@task.user).to eq(@user)

        expect(response).to redirect_to(task_path(@task))
      end

      it 'and update task' do
        @task = create(:task, user: @user)
        expect {
          put :update, id: @task.id, task: task_attributes
        }.not_to change(Task, :count)

        @edited_task = assigns(:task)
        expect(@task.id).to eq(@edited_task.id)
        task_attributes.each do |attribute, value|
          expect(@edited_task[attribute]).not_to eq(@task[attribute])
          expect(@edited_task[attribute]).to eq(value)
        end

        expect(response).to redirect_to(task_path(@edited_task))
      end
    end
  end

end
