class User < ActiveRecord::Base
  include Authentication
  has_many :tasks, dependent: :destroy

  validates :email, uniqueness: true
end
