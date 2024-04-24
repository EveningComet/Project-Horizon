## Keeps track of all of the stored classes a player character can be in the
## game.
extends Node

## Stores the database.
var character_class_db: Array[CharacterClass] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var character_class_data_path: String = "res://Game Data/Player Character Classes/Class Data/"
	var dir = DirAccess.open( character_class_data_path )
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres") == true:
				var found_class: CharacterClass = load(
					character_class_data_path + "/" + file_name
				)
				character_class_db.append( found_class )
			file_name = dir.get_next()
		dir.list_dir_end()

func get_database() -> Array[CharacterClass]:
	return character_class_db
