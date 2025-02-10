class CreateProjectTransitions < ActiveRecord::Migration[8.0]
  def change
    create_table :project_transitions do |t|
      t.references :project, null: false, foreign_key: true
      t.string :to_state
      t.integer :sort_key
      t.jsonb :metadata
      t.boolean :most_recent, null: false, default: true
      t.timestamps
    end
  end
end
