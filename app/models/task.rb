class Task < ActiveRecord::Base
  belongs_to :user

  scope :for, ->(user) { user.admin? ? where(nil) : where(user_id: user.id) }
  scope :get, ->(id) { where(id: id).first }

  validates :name, presence: true

  mount_uploader :file, TaskFileUploader

  state_machine initial: :new do
    state :started, :finished
    event :start do
      transition new: :started
    end
    event :finish do
      transition [:new, :started] => :finished
    end
  end

  def has_file?
    file.present?
  end
end
