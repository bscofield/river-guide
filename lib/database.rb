class Database
  def self.setup
    conn = connection
    conn.exec("CREATE TABLE history (title VARCHAR NOT NULL PRIMARY KEY, price DOUBLE NOT NULL, recorded_at DATETIME NOT NULL)")
  end

  def self.connection
    PG.connect(ENV['DATABASE_URL'])
  end
end
