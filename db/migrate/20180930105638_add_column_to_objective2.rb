class AddColumnToObjective2 < ActiveRecord::Migration[5.1]
  def change
    add_column :objectives, :reducing, :boolean
  end
end
