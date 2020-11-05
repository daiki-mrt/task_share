class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.integer :occupation_id
      t.text :text
      t.timestamps
    end
  end
end