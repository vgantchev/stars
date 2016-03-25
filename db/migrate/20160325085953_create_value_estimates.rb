class CreateValueEstimates < ActiveRecord::Migration
  def change
    create_table :value_estimates do |t|
      t.references :user, index: true, foreign_key: true
      t.references :interesting_object, index: true, foreign_key: true
      t.decimal :value, default: 0
      t.timestamps null: false
    end
  end
end
