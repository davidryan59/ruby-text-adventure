require('pry')
# require_relative("./models/model")
# require_relative("./models/command")
# require_relative("./models/room")
require_relative("./models/door")
require_relative("./models/item")

# PROBABLY WANT TO RESET DATABASE USING SEEDS HERE

def describe_current_room(room_id)
  room = Room.find(room_id)
  door_command_names = room.door_command_names
  door_text = door_command_names.inject{|memo, txt| memo + ", " + txt}
  puts "You are in the " + room.name
  puts room.description
  puts "There are doors to the " + door_text
  return room.door_commands
end

def update_room_id(command_text, room_id)
  room = Room.find(room_id)
  door = room.door_matching_command(command_text)
  # binding.pry
  unless door.nil?
    return new_room_id = door.linked_room_id
  end
  return room.id
end


quit_commands = ["quit", "end", "finish"]

current_room_id = 1    # Start in first room listed!
current_command = ""
until quit_commands.include?(current_command)
  room_commands = describe_current_room(current_room_id)
  print ">> "; current_command = gets.chomp
  puts
  current_room_id = update_room_id(current_command, current_room_id)
end

puts "Nice to see you! Bye."
