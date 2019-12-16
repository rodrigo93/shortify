class CreateShortens < ActiveRecord::Migration[6.0]
  def change
    create_table :shortens do |t|
      t.datetime :startDate
      t.datetime :lastSeenDate
      t.integer :redirectCount, default: 0
      t.string :url, null: false
      t.string :shortcode, null: false

      t.timestamps
    end
  end
end
