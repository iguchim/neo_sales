class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8"  do |t|
      t.string :name
    end
  end
end
