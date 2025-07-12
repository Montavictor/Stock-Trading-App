class AddColumnsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :username, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :is_admin, :boolean
    add_column :users, :balance, :integer
    add_column :users, :status, :boolean
  end
end
