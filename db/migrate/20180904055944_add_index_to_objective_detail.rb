class AddIndexToObjectiveDetail < ActiveRecord::Migration[5.1]
  def change
    add_reference :objective_details, :auth, foreign_key: { to_table: :users}
  end
end
