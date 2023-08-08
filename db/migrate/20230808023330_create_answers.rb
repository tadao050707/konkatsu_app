class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :response, array: true, default: []

      t.timestamps
    end
  end
end
