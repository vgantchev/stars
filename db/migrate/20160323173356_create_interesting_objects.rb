class CreateInterestingObjects < ActiveRecord::Migration
  def change
    create_table :interesting_objects do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, index: true, foreign_key: true
      t.attachment :photo
      t.decimal :average_rating
      t.decimal :average_value_estimate
      t.timestamps null: false
    end
  end
end
