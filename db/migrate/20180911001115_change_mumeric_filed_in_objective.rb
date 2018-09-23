class ChangeMumericFiledInObjective < ActiveRecord::Migration[5.1]
  def change
    change_column :objectives, :goal_amount, :decimal, :precision => 10, :scale => 1
    change_column :objectives, :current_amount, :decimal, :precision => 10, :scale => 1
  end
end
