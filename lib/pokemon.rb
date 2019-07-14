class Pokemon
  attr_accessor :id, :name, :type
  
  def initialize(id: nil, name: 'Pikachu', type: 'electric', db:)
    @id = id 
    @name = name 
    @type = type
    @db = db 
  end 
  
  def self.create_table
    sql = <<-SQL 
     CREATE TABLE IF NOT EXISTS pokemon (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      type TEXT, 
      db TEXT
      )
    SQL
   
   DB[:conn].execute(sql) 
  end
  
  def save
    if self.id
    else
      sql = <<-SQL
        INSERT INTO pokemons (name, type) 
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.type)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM pokemons")[0][0]
    end 
  end
  
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    type = row[2]
    self.new(id, name, type)
  end 
  
  def self.find(name)
    # find the pokemon in the database given a name
    # return a new instance of the Pokemon class
    sql = <<-SQL
      SELECT *
      FROM Pokemons
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
 end 
end
