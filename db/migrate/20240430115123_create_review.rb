class CreateReview < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :title
      t.string :content
      t.integer :rating
      t.bigint :reviewable_id
      t.string :reviewable_type
      t.timestamps
    end
    add_index :reviews, [:reviewable_id, :reviewable_type]
  end
end
