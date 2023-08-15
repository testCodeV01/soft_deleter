class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.references :book, null: false, foreign_key: true
      t.string :title

      t.string :deleter_type
      t.integer :deleter_id
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
