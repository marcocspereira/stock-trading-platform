class CreateBuyOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :buy_orders do |t|
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.references :business, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.string :status, null: false
      t.timestamps
    end
  end
end
