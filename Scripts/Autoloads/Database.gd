## Keeps track of various databases for the game.
extends Node

const MALE: String   = "MALE"
const FEMALE: String = "FEMALE"
const UNISEX: String = "UNISEX"

## Stores the database for character classes.
var character_class_db: Array[CharacterClass] = []

var char_names: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_character_classes()
	load_character_names()

func load_character_classes() -> void:
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

## Loads the character names and stores them.
func load_character_names() -> void:
	char_names[MALE]   = []
	char_names[FEMALE] = []
	char_names[UNISEX] = []
	
	var char_names_path: String = "res://Game Data/Character Names For Generator/Character Names.csv"
	var file = FileAccess.open(char_names_path, FileAccess.READ)
	while file.eof_reached() == false:
		var csv = file.get_csv_line()
		
		if csv[0] != MALE and csv[0] != "":
			char_names[MALE].append(csv[0])
		
		if csv.size() > 1:
			if csv[1] != FEMALE and csv[1] != "":
				char_names[FEMALE].append(csv[1])
		
		if csv.size() > 2:
			if csv[2] != UNISEX and csv[2] != "":
				char_names[UNISEX].append(csv[2])
				
	if OS.is_debug_build() == true:
		print("Database :: The names are: ", char_names)
	
	file.close()
	

func get_character_class_database() -> Array[CharacterClass]:
	return character_class_db

func get_male_name() -> String:
	var potential_names: PackedStringArray = char_names[MALE]
	potential_names.append_array(char_names[UNISEX])
	var index: int = randi_range(0, potential_names.size() - 1)
	var chosen_name: String = potential_names[index]
	return chosen_name

func get_female_name() -> String:
	var potential_names: PackedStringArray = char_names[FEMALE]
	potential_names.append_array(char_names[UNISEX])
	var index: int = randi_range(0, potential_names.size() - 1)
	var chosen_name: String = potential_names[index]
	return chosen_name

func is_male_portrait(portrait_data: PortraitData) -> bool:
	for c in character_class_db:
		if c.male_portraits.has(portrait_data) == true:
			return true
	return false

func is_female_portrait(portrait_data: PortraitData) -> bool:
	for c in character_class_db:
		if c.female_portraits.has(portrait_data) == true:
			return true
	return false

