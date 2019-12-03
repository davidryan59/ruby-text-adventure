-- SETUP IN TERMINAL
-- dropdb text_adventure
-- createdb text_adventure
-- psql -d text_adventure -f db/text_adventure.sql
-- ruby db/seeds.rb

DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS doors;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS commands;

CREATE TABLE commands (
  id SERIAL PRIMARY KEY,
  name VARCHAR(20)
);

CREATE TABLE rooms (
  id SERIAL PRIMARY KEY,
  name VARCHAR(31),
  description VARCHAR(255)
);

CREATE TABLE doors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  this_room_id INT REFERENCES rooms(id),
  linked_room_id INT REFERENCES rooms(id),
  command_id INT REFERENCES commands(id)
);

CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  name VARCHAR(31),
  description VARCHAR(255),
  room_id INT REFERENCES rooms(id)
);
