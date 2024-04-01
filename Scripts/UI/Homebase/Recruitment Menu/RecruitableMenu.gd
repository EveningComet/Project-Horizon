## Responsible for displaying the recruitable classes to the player.
class_name RecruitableMenu extends Control

signal close_recruitable_menu

@export var character_name_entry: CharacterNameInputScreen

## The container housing the displayed classes.
@export var container: Container

## Template of the button of the class.
@export var character_class_button_template: PackedScene

## Stores the new character we want to add.
var new_character: PlayerCombatant

## The class for the character being created.
var initial_class: CharacterClass

## Used to prevent other menus from doing things while the player is choosing a
## portrait, entering a name, etc.
var player_is_doing_something: bool = false

# TODO: Figure out how to handle creating more than the max recruitable size.
func _unhandled_input(event: InputEvent) -> void:
	if visible == true:
		if event.is_action_pressed("ui_cancel"):
			# Make sure all the relevant menus are closed before doing anything else
			if player_is_doing_something == true:
				# TODO: Check which menu is open first. The menus should be closed in order.
				character_name_entry.close()
				player_is_doing_something = false
				return
			close_recruitable_menu.emit()
		

func display_classes(pc_classes: Array[CharacterClass]) -> void:
	# Delete the previously displayed classes.
	clear_displayed_classes()
	
	# Create the buttons representing the classes
	for pc_class in pc_classes:
		var char_class_button = character_class_button_template.instantiate() as CharacterClassButton
		char_class_button.setup_button( pc_class )
		char_class_button.on_player_selected_class.connect( on_class_selected )
		container.add_child( char_class_button )
	
	# Subscribe to any relevant events
	character_name_entry.player_finished_entering_name.connect( on_player_finished_entering_name )
	
	# Set the focus and display
	container.get_child(0).grab_focus()
	show()

func clear_displayed_classes() -> void:
	for child: CharacterClassButton in container.get_children():
		child.on_player_selected_class.disconnect( on_class_selected )
		child.queue_free()

func close() -> void:
	hide()
	new_character = null
	initial_class = null
	player_is_doing_something = false
	character_name_entry.player_finished_entering_name.disconnect( on_player_finished_entering_name )

## Called when the player selects a character class. This will make the player
## select a portrait.
func on_class_selected(pc_class: CharacterClass) -> void:
	# The player has selected a class for their new character. The player must
	# now select a portrait for the character
	
	# The player has finished selecting a portrait, initialize the stats
	# TODO: Implement portrait selection. For now, just make the player enter a name.
	player_is_doing_something = true
	new_character = PlayerCombatant.new()
	initial_class = pc_class
	new_character.set_pc_class( pc_class ) # TODO: Move setting the class to after the name has been entered.
	new_character.initialize_with_class_data( pc_class )
	add_child( new_character )
	
	# TODO: Proper skill adding. For now, just add all the skills
	# Add the relevant skills to the character
	new_character.available_skills.append_array( pc_class.skills )
	
	character_name_entry.start_accepting_input( new_character )

func on_portrait_selected() -> void:
	pass

## When the player finishes entering the name for their created character,
## see what has to be done. If the player's party has space, the created character
## will be added.
func on_player_finished_entering_name() -> void:
	# TODO: Make sure we are not going over the party limit for the newly created character.
	# TODO: Notify the player that the character has been added to their party.
	new_character.reparent( PlayerPartyController )
	character_name_entry.close()
	player_is_doing_something = false
	initial_class = null
	new_character = null