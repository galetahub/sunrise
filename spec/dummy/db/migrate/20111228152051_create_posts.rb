class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, :null => false
      t.text :content
      t.boolean :is_visible, :default => true
      t.integer :structure_id, :null => false

      t.timestamps
    end
    
    add_index :posts, :structure_id
  end
end
