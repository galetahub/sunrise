# frozen_string_literal: true

class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table(:settings) do |t|
      t.string  :var, limit: 50, null: false
      t.text    :value
      t.integer :thing_id
      t.string  :thing_type, limit: 30
      t.timestamps
    end

    add_index :settings, [:thing_type, :thing_id, :var], unique: true
  end

  def self.down
    drop_table :settings
  end
end
