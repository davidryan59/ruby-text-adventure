require('pry')
require_relative("../db/sql_runner")

class Model

  # ONLY IN MODEL
  # Info Store stores database info for each subclass of Model
  # @@info is a hash, keys are class names
  # Values are also hashes with entry for name (table name) and cols (column names)
  # Initialise @@info once in Model
  @@info = {}

  # Access for table, column info for this class
  def self.setup_info_store
    @@info[self] = {}
  end
  def self.info_store
    return @@info
  end
  def self.table_name(class_name=self)
    return @@info[class_name][:name]
  end
  def self.set_table_name(name_string)
    @@info[self][:name] = name_string
  end
  def self.columns
    return @@info[self][:cols]
  end
  def self.set_columns(string_array)
    @@info[self][:cols] = string_array
  end

  # IN EACH SUBCLASS
  # Make a hash to store table structure for this class
  self.setup_info_store
  # Set database table name
  self.set_table_name("models")
  # Set database table columns
  self.set_columns([])
  # These ensure that save, find etc methods work in subclasses.

  # SQL text snippets for this class
  def self.save_vars_text                 # e.g. turn ["col1", "col2"] into "col1, col2"
    result = ""
    self.columns.each{|col_name_text| result << col_name_text << ", "}
    return result.chop.chop
  end
  def self.save_params_text               # e.g. turn ["col1", "col2"] into "$1, $2"
    result = ""
    (1..self.columns.size).each{|n| result << "$" << n.to_s << ", "}
    return result.chop.chop
  end
  def self.update_param_text               # e.g. if ["col1", "col2"] then return "$3"
    return "$" << (self.columns.size + 1).to_s
  end

  attr_reader :id
  # attr_accessor (vars in subclass)

  def initialize(option_hash)
    option_hash.each { |key, value|
      instance_variable_set("@"+key, value) unless ( key=='id' && value.nil? ) || !(self.class.columns.include?(key) || key=='id')
    }
  end

  def get_save_array
    return self.class.columns.map{|col_name_text| instance_variable_get("@#{col_name_text}")}
  end

  def get_update_array
    return get_save_array << @id
  end

  def save
    @id.nil? ? save_to_db : update_in_db
  end

  def save_to_db
    the_class = self.class
    sql = "
      INSERT INTO #{the_class.table_name} ( #{the_class.save_vars_text} )
      VALUES ( #{the_class.save_params_text} )
      RETURNING id
      ;"
    sql_object_rows = SqlRunner.run(sql, get_save_array)
    return nil if sql_object_rows.none?
    @id = sql_object_rows[0]['id'].to_i      # id of first row only
  end

  def update_in_db
    the_class = self.class
    sql = "
      UPDATE #{the_class.table_name}
      SET (#{the_class.save_vars_text}) = (#{the_class.save_params_text})
      WHERE id = #{the_class.update_param_text}
      ;"
    SqlRunner.run(sql, get_update_array)
  end

  def delete
    the_table = self.class.table_name
    sql = "DELETE FROM #{the_table} WHERE id = $1;"
    SqlRunner.run(sql, [@id])
  end

  def self.all
    sql = "SELECT * FROM #{self.table_name};"
    sql_object_rows = SqlRunner.run(sql)
    return sql_object_rows.map{|object_row| self.new(object_row)}
  end

  def self.find_by_value(field, value)
    sql = "SELECT * FROM #{self.table_name} WHERE #{field} = $1;"
    sql_object_rows = SqlRunner.run(sql, [value])
    return nil if sql_object_rows.none?
    return self.new(sql_object_rows[0])
  end

  def self.find(id)
    sql = "SELECT * FROM #{self.table_name} WHERE id = $1;"
    sql_object_rows = SqlRunner.run(sql, [id])
    return nil if sql_object_rows.none?
    return self.new(sql_object_rows[0])
  end

  def find_parent(parent_id, parent_class)
    parent_table = Model.table_name(parent_class)
    sql = "SELECT * FROM #{parent_table} WHERE id = $1;"
    sql_object_rows = SqlRunner.run(sql, [parent_id])
    return nil if sql_object_rows.none?
    return parent_class.new(sql_object_rows[0])
  end

  def find_children(child_col, child_class)
    child_table = Model.table_name(child_class)
    sql = "SELECT * FROM #{child_table} WHERE #{child_col} = $1;"
    sql_object_rows = SqlRunner.run(sql, [@id])
    return sql_object_rows.map{|object_row| child_class.new(object_row)}
  end

  def find_join(join_start_col, join_class, join_dest_col, dest_class)
    join_table = Model.table_name(join_class)
    dest_table = Model.table_name(dest_class)
    sql = "
        SELECT *
        FROM #{dest_table}
        WHERE id IN
        (
          SELECT #{join_dest_col}
          FROM #{join_table}
          WHERE #{join_start_col} = $1
        );
      "
    sql_object_rows = SqlRunner.run(sql, [@id])
    return sql_object_rows.map{|object_row| dest_class.new(object_row)}
  end

  def self.delete_all
    sql = "DELETE FROM #{self.table_name};"
    SqlRunner.run(sql)
  end

end
