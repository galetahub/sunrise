# frozen_string_literal: true

class CreateMetaTags < ActiveRecord::Migration[7.2]
  def self.up
    create_table :meta_tags do |t|
      t.string :name, limit: 50, null: false
      t.text :content
      t.boolean :is_dynamic, default: false

      t.integer :taggable_id, null: false
      t.string :taggable_type, limit: 50, null: false

      t.timestamps
    end

    add_index :meta_tags, :name
    add_index :meta_tags, [:taggable_type, :taggable_id]
  end

  def self.down
    drop_table :meta_tags
  end
end
