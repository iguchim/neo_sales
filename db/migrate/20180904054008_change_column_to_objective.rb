class ChangeColumnToObjective < ActiveRecord::Migration[5.1]
  def change
    remove_column :objectives, :auth, :string
  end
end
