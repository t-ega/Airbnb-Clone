class RemoveAverageRatingFromReviews < ActiveRecord::Migration[7.1]
  def change
    remove_column :reviews, :average_rating
    add_column :properties, :average_rating, :decimal
  end
end
