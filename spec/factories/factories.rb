FactoryGirl.define do
  sequence :email do |n|
    "example_#{n}@gmail.com"
  end
end
