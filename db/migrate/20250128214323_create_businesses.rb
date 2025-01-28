class CreateBusinesses < ActiveRecord::Migration[8.0]
  def change
    create_table :businesses do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.integer :total_shares, null: false, default: 0
      t.integer :available_shares, null: false, default: 0
      t.timestamps
    end
  end
end
