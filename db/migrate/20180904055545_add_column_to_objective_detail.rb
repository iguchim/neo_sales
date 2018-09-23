class AddColumnToObjectiveDetail < ActiveRecord::Migration[5.1]
  def change
    add_column :objective_details, :state, :string
  end
end
