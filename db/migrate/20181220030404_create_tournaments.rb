class CreateTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :tournaments do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.integer :start_at, null: false
      t.integer :end_at, null: false
      t.integer :api_id, null: false
      t.timestamps
    end
  end
end

