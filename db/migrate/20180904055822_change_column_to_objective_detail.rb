class ChangeColumnToObjectiveDetail < ActiveRecord::Migration[5.1]
  def change
    remove_column :objective_details, :auth, :string
  end
end
