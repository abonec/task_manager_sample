FactoryGirl.define do
  factory :user do
    email
    password 'secret'
  end

  factory :admin, parent: :user do
    role 'admin'
  end

end
