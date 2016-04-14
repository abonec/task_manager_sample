class User < ActiveRecord::Base
  include Authentication
  has_many :tasks, dependent: :destroy

  validates :email, uniqueness: true

  def become_admin!
    update_attribute(:role, :admin)
  end

  def admin?
    role.to_s == 'admin'
  end
end
