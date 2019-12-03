require_relative("model")

class Command < Model

  self.setup_info_store
  self.set_table_name("commands")
  self.set_columns(["name"])

  attr_reader :id
  attr_accessor :name

  # # SAMPLE STATEMENTS
  # def customers
  #   return find_join('screening_id', Ticket, 'customer_id', Customer)
  # end
  # def this_room
  #   return find_parent(@this_room_id, Room)
  # end
  # def doors
  #   return find_children("this_room_id", Door)
  # end

end
