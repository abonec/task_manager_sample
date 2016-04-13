FactoryGirl.define do
  factory :task do
    name 'task name'
    description 'task description'
    user
  end
end
