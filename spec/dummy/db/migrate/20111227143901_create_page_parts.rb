# frozen_string_literal: true

class CreatePageParts < ActiveRecord::Migration[7.2]
  def self.up
    create_table :page_parts do |t|
      t.string :key, limit: 10, null: false
      t.text :content

      t.integer :partable_id, null: false
      t.string :partable_type, limit: 50, null: false

      t.timestamps
    end

    add_index :page_parts, :key
    add_index :page_parts, [:partable_type, :partable_id]
  end

  def self.down
    drop_table :page_parts
  end
end
