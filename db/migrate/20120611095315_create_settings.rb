class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table(:settings) do |t|
      t.string  :var, :limit => 50, :null => false
      t.text    :value
      t.integer :target_id
      t.string  :target_type, :limit => 30
      t.timestamps
    end
    
    add_index :settings, [:var, :target_type, :target_id], :unique => true
  end
  
  def self.down
    drop_table :settings
  end
end
