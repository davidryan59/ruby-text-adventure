# require_relative("model")
require_relative("command")
require_relative("room")

class Door < Model

  self.setup_info_store
  self.set_table_name("doors")
  self.set_columns(["name", "this_room_id", "linked_room_id", "command_id"])

  attr_reader :id, :this_room_id, :linked_room_id, :command_id
  attr_accessor :name

  def this_room
    return find_parent(@this_room_id, Room)
  end
  def linked_room
    return find_parent(@linked_room_id, Room)
  end
  def command
    return find_parent(@command_id, Command)
  end

end
