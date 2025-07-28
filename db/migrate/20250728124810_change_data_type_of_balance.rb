class ChangeDataTypeOfBalance < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :balance, :float
  end
end
