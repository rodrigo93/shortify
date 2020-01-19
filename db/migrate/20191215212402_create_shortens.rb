class CreateShortens < ActiveRecord::Migration[6.0]
  def change
    create_table :shortens do |t|
      t.datetime :start_date
      t.datetime :last_seen_date
      t.integer :redirect_count, default: 0
      t.string :url, null: false
      t.string :shortcode, null: false, unique: true

      t.timestamps
    end
  end
end
