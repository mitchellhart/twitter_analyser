class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.float :score_f
      t.integer :score_i

      t.timestamps null: false
    end
  end
end
