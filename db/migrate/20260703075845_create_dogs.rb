class CreateDogs < ActiveRecord::Migration[8.0]
  def change
    create_table :dogs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :breed, null: false
      t.integer :size, null: false
      t.date :birthday, null: false
      t.integer :gender, null: false

      t.timestamps
    end
  end
end
