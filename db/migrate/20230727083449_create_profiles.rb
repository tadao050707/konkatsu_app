class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.text :icon
      t.string :name
      t.integer :sex
      t.integer :age
      t.string :work
      t.string :hobby
      t.string :likes
      t.string :comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
