class Task < ActiveRecord::Base
  belongs_to :user

  scope :for, ->(user) { user.admin? ? where(nil) : where(user_id: user.id) }
  scope :get, ->(id) { where(id: id).first }

  validates :name, presence: true

  state_machine initial: :new do
    state :started, :finished
  end
end
