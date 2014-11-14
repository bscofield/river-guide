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
    @connection ||= Sequel.connect(ENV['DATABASE_URL'])
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
  rescue StandardError
    []
  end

  def self.find_drops(books)
    books.each do |book|
      data = connection['SELECT MAX(price) AS max FROM history WHERE title = ?', book.title]
      book.max = data.all.first[:max]
    end

    books.select {|book| book.max.to_f > book.price.to_f}
  end
end
