# require_relative("model")
require_relative("room")

class Item < Model

  self.setup_info_store
  self.set_table_name("items")
  self.set_columns(["name", "description", "room_id"])

  attr_reader :id, :room_id
  attr_accessor :name, :description

  def room
    return find_parent(@room_id, Room)
  end

end
