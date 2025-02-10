class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, null: false
      t.references :user, null: false
      t.boolean :auto_generated, default: false, null: false
      t.timestamps
    end
  end
end
