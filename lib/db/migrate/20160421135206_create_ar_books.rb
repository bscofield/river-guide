require_relative '../../environment'

class CreateArBooks < ActiveRecord::Migration

  def self.up
    create_table :ar_books do |t|
      t.string :title
      t.float :max_price
      t.float :last_price
      t.float :current_price
      t.datetime :last_seen
    end
  end

  def self.down
    drop_table :ar_books
  end

end
