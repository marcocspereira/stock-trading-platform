class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :business, null: false, foreign_key: true
      t.decimal :price, null: false, precision: 10, scale: 2
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end
