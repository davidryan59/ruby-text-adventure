require_relative('../models/door')
require_relative('../models/item')

Door.delete_all
Item.delete_all
Room.delete_all
Command.delete_all

# COMMAND

quit = Command.new({"name"=>"quit"})
quit.save
north = Command.new({"name"=>"north"})
north.save
south = Command.new({"name"=>"south"})
south.save
east = Command.new({"name"=>"east"})
east.save
west = Command.new({"name"=>"west"})
west.save
northeast = Command.new({"name"=>"northeast"})
northeast.save
northwest = Command.new({"name"=>"northwest"})
northwest.save
southeast = Command.new({"name"=>"southeast"})
southeast.save
southwest = Command.new({"name"=>"southwest"})
southwest.save
pick = Command.new({"name"=>"pick"})
pick.save

# ROOM

lounge = Room.new({"name"=>"Lounge", "description"=>
  "A rather average looking lounge, soiled from the activities of many small children"
  })
lounge.save

hallway = Room.new({"name"=>"Hallway", "description"=>
  "An L-shaped hallway which has photographs of family members"
  })
hallway.save

room3 = Room.new({"name"=>"Small Bedroom", "description"=>
  "Nursery with many peeling pictures of giraffes and elephants, aimed at a younger audience"
  })
room3.save

# DOOR

Door.new({
    "this_room_id" => lounge.id,
    "linked_room_id" => room3.id,
    "command_id" => east.id,
    "description" => "A sliding door"
  }).save
Door.new({
    "this_room_id" => room3.id,
    "linked_room_id" => lounge.id,
    "command_id" => west.id
  }).save

Door.new({
    "this_room_id" => lounge.id,
    "linked_room_id" => hallway.id,
    "command_id" => north.id
  }).save
Door.new({
    "this_room_id" => hallway.id,
    "linked_room_id" => lounge.id,
    "command_id" => south.id
  }).save

Door.new({
    "this_room_id" => room3.id,
    "linked_room_id" => hallway.id,
    "command_id" => northwest.id
  }).save
Door.new({
    "this_room_id" => hallway.id,
    "linked_room_id" => room3.id,
    "command_id" => southeast.id
  }).save

# ITEM

cot = Item.new({
    "name" => "Cot",
    "description" => "A rather old and battered child's cot",
    "room_id" => room3.id
  })
cot.save
