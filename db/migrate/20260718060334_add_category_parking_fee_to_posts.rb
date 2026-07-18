class AddCategoryParkingFeeToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :category, :integer
    add_column :posts, :parking, :integer
    add_column :posts, :fee, :integer
  end
end
