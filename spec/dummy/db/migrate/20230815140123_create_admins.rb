class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :name

      t.string :deleter_type
      t.integer :deleter_id
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
