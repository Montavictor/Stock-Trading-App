class ChangeStocksUserIdToNullable < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :stocks, :users
    change_column_null :stocks, :user_id, true
    add_foreign_key :stocks, :users, on_delete: :nullify
  end
end
