class AddDefaultRoleToUser < ActiveRecord::Migration
  def change
    change_column :users, :role, :string, default: :regular
  end
end
