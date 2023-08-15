class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name

      t.string :deleter_type
      t.integer :deleter_id
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
