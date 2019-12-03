require_relative("model")
require_relative("door")
require_relative("item")

class Room < Model

  self.setup_info_store
  self.set_table_name("rooms")
  self.set_columns(["name", "description"])

  attr_reader :id
  attr_accessor :name, :description

  def doors
    return find_children("this_room_id", Door)
  end
  def items
    return find_children("room_id", Item)
  end

  def door_commands
    return doors.map{|door| door.command}
  end
  def door_command_names
    return door_commands.map{|command| command.name}
  end

  def door_matching_command(command_text)
    doors.each do |door|
      match_text = door.command.name
      return door if command_text==match_text
    end
    return nil
  end

end
