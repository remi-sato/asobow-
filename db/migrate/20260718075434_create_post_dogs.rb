class CreatePostDogs < ActiveRecord::Migration[8.0]
  def change
    create_table :post_dogs do |t|
      t.references :post, null: false, foreign_key: true
      t.references :dog, null: false, foreign_key: true

      t.timestamps
    end

    add_index :post_dogs, [ :post_id, :dog_id ], unique: true
  end
end
