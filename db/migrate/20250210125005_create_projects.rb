class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.datetime :deadline
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
