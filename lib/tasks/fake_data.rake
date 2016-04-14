require 'faker'
namespace :db do
  desc 'add fake data to the database'
  task add_fake_data: :environment do
    5.times do
      user = User.register!(Faker::Internet.email, 'secret')
      rand(5..10).times do
        Task.create(name: Faker::Book.title, description: Faker::Shakespeare.hamlet_quote, user: user)
      end
    end

  end
end