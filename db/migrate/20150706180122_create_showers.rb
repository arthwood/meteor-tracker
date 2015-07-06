class CreateShowers < ActiveRecord::Migration
  def change
    create_table :showers do |t|
      t.string :name, null: false
    end
    
    add_index :showers, :name, unique: true
  end
end
