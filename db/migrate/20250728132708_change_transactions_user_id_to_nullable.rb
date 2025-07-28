class ChangeTransactionsUserIdToNullable < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :transactions, :users
    change_column_null :transactions, :user_id, true
    add_foreign_key :transactions, :users, on_delete: :nullify
  end
end
