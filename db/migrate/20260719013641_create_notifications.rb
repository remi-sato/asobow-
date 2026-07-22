class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :visitor, null: false, foreign_key: { to_table: :users }
      t.references :visited, null: false, foreign_key: { to_table: :users }

      t.references :post, foreign_key: true
      t.references :comment, foreign_key: true
      t.references :community, foreign_key: true

      t.integer :action, null: false
      t.boolean :checked, null: false, default: false

      t.timestamps
    end
  end
end
