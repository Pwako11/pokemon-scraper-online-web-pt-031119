class Pokemon
  attr_accessor :id, :name, :type
  
  def initialize(id:, name:, type:, hp: nil, db:)
    @id,  @name, @type, @hp, id = name, type, hp, db
  end 
  
  def self.save (name, type, db)
    db.execute("INSERT INTO pokemon (name, type) 
        VALUES (?, ?)", name, type)
  end

  def self.find(id_num, db)
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
