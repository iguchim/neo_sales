class RenameNotice < ActiveRecord::Migration[5.1]
  def change
    rename_column :notices, :notices, :notes
  end
end
