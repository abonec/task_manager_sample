require 'rails_helper'

describe TasksController, type: :controller do
  describe 'should redirect if not signed in' do
    {
      index: { method: :get },
      edit: { method: :get, params: { id: 1 } },
      show: { method: :get, params: { id: 1 } },
      update: { method: :put, params: { id: 1 } }
    }.each do |action, options|
      it "from #{action}" do
        send(options[:method], action, options[:params])
        expect(response).to redirect_to new_sessions_path
      end
    end
  end
  describe 'should works with tasks' do
    describe 'as admin user' do
      before :each do
        @admin = create(:admin)
        @admin_task = create(:task, user: @admin)
        @task1 = create(:task)
        @task2 = create(:task)
        sign_in @admin
      end

      it 'should see all tasks' do
        get :index
        expect(assigns(:tasks).sort).to eq([@admin_task, @task1, @task2].sort)
      end

      %i(show edit).each do |action|
        it "should #{action} foreign tasks" do
          get action, id: @task1.id
          expect(assigns(:task)).to eq(@task1)
        end
      end

      it 'should update foreign tasks' do
        name = 'new task name'
        put :update, id: @task1.id, task: { name: name }
        expect(response).to redirect_to(task_path(@task1))
        expect(assigns(:task).name).to eq(name)
      end

      it 'should delete foreign tasks' do
        expect do
          delete :destroy, id: @task1.id
        end.to change(Task, :count).by(-1)
        expect(response).to redirect_to(tasks_path)
      end

      it 'should change user_id in tasks' do
        @new_user = create(:user)
        expect(@new_user).not_to eq(@task1.user)
        put :update, id: @task1.id, task: { user_id: @new_user.id }
        expect(assigns(:task).user).to eq(@new_user)
      end
    end
    describe 'as normal user' do
      before :each do
        @user = create(:user)
        sign_in @user
      end

      it 'and show all own tasks' do
        @task1 = create(:task, user: @user)
        @task2 = create(:task, user: @user)
        create(:task, user: create(:admin))
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

      let (:task_attributes) do
        { name: 'task_name', description: 'description' }
      end
      it 'and create task' do
        expect do
          post :create, task: task_attributes
        end.to change(Task, :count).to 1

        @task = assigns(:task)
        expect(@task.name).to eq(task_attributes[:name])
        expect(@task.description).to eq(task_attributes[:description])
        expect(@task).to be_persisted
        expect(@task.user).to eq(@user)

        expect(response).to redirect_to(task_path(@task))
      end

      it 'and update task' do
        @task = create(:task, user: @user)
        expect do
          put :update, id: @task.id, task: task_attributes
        end.not_to change(Task, :count)

        @edited_task = assigns(:task)
        expect(@task.id).to eq(@edited_task.id)
        task_attributes.each do |attribute, value|
          expect(@edited_task[attribute]).not_to eq(@task[attribute])
          expect(@edited_task[attribute]).to eq(value)
        end

        expect(response).to redirect_to(task_path(@edited_task))
      end

      it 'and can\'t update task\'s user_id' do
        @task = create(:task, user: @user)
        @new_user = create(:user)
        put :update, id: @task.id, task: { user_id: @new_user.id }
        expect(assigns(:task).user).to eq(@user)
      end
    end
  end
end
