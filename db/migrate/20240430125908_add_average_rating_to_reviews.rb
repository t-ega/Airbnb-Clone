class AddAverageRatingToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :average_rating, :decimal
  end
end
