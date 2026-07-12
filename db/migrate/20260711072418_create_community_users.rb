class CreateCommunityUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :community_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :community, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :community_users, [:user_id, :community_id], unique: true
  end
end
