class CreateCommunities < ActiveRecord::Migration[6.0]
  def change
    create_table :communities do |t|
      t.string :name, null: false
      t.integer :category_id
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
