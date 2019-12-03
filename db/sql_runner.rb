require('pg')
class SqlRunner

  @@dbname = 'text_adventure'
  @@hostname = 'localhost'

  def self.run( sql, values=[] )
    begin
      db = PG.connect({ dbname: @@dbname, host: @@hostname })
      db.prepare("query", sql)
      result = db.exec_prepared( "query", values )
    ensure
      db.close
    end
    return result
  end

end
