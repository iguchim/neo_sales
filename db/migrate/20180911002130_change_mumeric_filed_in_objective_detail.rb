class ChangeMumericFiledInObjectiveDetail < ActiveRecord::Migration[5.1]
  def change
    change_column :objective_details, :amount, :decimal, :precision => 10, :scale => 1
  end
end
