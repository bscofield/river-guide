require 'sequel'
require 'pg'

class Database
  def self.setup
    conn = connection
    conn.create_table(:history) do
      String :title, primary_key: true
      Float :price
      DateTime :recorded_at
    end
  end

  def self.connection
    Sequel.connect(ENV['DATABASE_URL'])
  end

  def self.save(books)
    conn = connection
    books.each do |book|
      data = {
        title: book.title,
        price: book.price,
        recorded_at: Time.now
      }
      conn[:history].insert data
    end
  end
end
