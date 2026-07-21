class CreateCommunityUserDogs < ActiveRecord::Migration[8.0]
  def change
    create_table :community_user_dogs do |t|
      t.references :community_user, null: false, foreign_key: true
      t.references :dog, null: false, foreign_key: true

      t.timestamps
    end

    add_index :community_user_dogs,
              [:community_user_id, :dog_id],
              unique: true
  end
end
