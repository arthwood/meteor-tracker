class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :time, null: false
      t.time :ra, null: false
      t.integer :dec, null: false
      t.string :dir, null: false
      t.integer :len
      t.decimal :mag
      t.integer :vel
      t.belongs_to :user
      t.belongs_to :shower
    end
    
    add_index :events, :user_id
    add_index :events, :shower_id
  end
end
