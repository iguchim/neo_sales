class CreateReferenceUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :reference_users do |t|
      t.bigint :refer_id
      t.bigint :referred_id

      t.timestamps
    end
  end
end
