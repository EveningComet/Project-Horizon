## The menu where the player organizes their party.
class_name PartyManagementMenu extends Control

signal close_party_management_menu

## The template for storing a generated character.
@export var template: PackedScene

## The node that ultimately houses the player's party.
@export var party_holder: PartyManagementHolder

## The node that ultimately stores the characters not in the player's party.
@export var recruited_holder: PartyManagementHolder

## Reference to the object that will display a the character the player is
## dragging.
@export var grabbed_ui: PartyMemberHolderUI

func _ready() -> void:
	recruited_holder.gui_input.connect( on_recruitment_holder_gui_input )
	party_holder.gui_input.connect( on_party_holder_gui_input )

func _unhandled_input(event: InputEvent) -> void:
	if visible == true and event.is_action_pressed("ui_cancel"):
		close_party_management_menu.emit()

func _input(event: InputEvent) -> void:
	if grabbed_ui.visible == true:
		# Display the grabbed slot at the mouse position, with an offset
		grabbed_ui.global_position = get_global_mouse_position() + Vector2(5, 5)

## Fired when the player clicks over the party holder node.
func on_party_holder_gui_input(event: InputEvent) -> void:
	if grabbed_ui.stored_character != null:
		if PlayerPartyController.get_party_count() < PlayerPartyController.MAX_RECRUITABLE_SIZE:
			if event.is_action("left_click"):
				if OS.is_debug_build() == true:
					print("PartyManagementMenu :: %s is being added to the party." % [grabbed_ui.stored_character.char_name])
				var new_pc_holder: PartyMemberHolderUI = template.instantiate()
				new_pc_holder.slot_clicked.connect( on_slot_clicked )
				new_pc_holder.stored_character = grabbed_ui.stored_character
				new_pc_holder.portrait.texture = grabbed_ui.portrait.texture
				PlayerPartyController.add_party_member( grabbed_ui.stored_character )
				party_holder.own_pc_holder.add_child( new_pc_holder )
				grabbed_ui.stored_character = null
				update_grabbed_slot()

## Fired when the player clicks over the recruitment holder node.
func on_recruitment_holder_gui_input(event: InputEvent) -> void:
	if grabbed_ui.stored_character != null:
		if event.is_action_pressed("left_click"):
			var new_pc_holder: PartyMemberHolderUI = template.instantiate()
			new_pc_holder.slot_clicked.connect( on_slot_clicked )
			new_pc_holder.stored_character = grabbed_ui.stored_character
			new_pc_holder.portrait.texture = grabbed_ui.portrait.texture
			recruited_holder.own_pc_holder.add_child( new_pc_holder )
			grabbed_ui.stored_character = null
			update_grabbed_slot()

func display() -> void:
	# Populate the grid storing the player's current party
	for i in PlayerPartyController.party_members.size():
		var party_member_holder: PartyMemberHolderUI = template.instantiate()
		party_member_holder.set_character( PlayerPartyController.party_members[i] )
		party_holder.own_pc_holder.add_child( party_member_holder )
		party_member_holder.slot_clicked.connect( on_slot_clicked )
	
	# Populate the recruitment
	for character in PlayerPartyController.get_children():
		if PlayerPartyController.party_members.has(character):
			continue
		var party_member_holder: PartyMemberHolderUI = template.instantiate()
		party_member_holder.set_character( character )
		recruited_holder.own_pc_holder.add_child( party_member_holder )
		party_member_holder.slot_clicked.connect( on_slot_clicked )
	
	show()

func close() -> void:
	hide()
	grabbed_ui.stored_character = null
	update_grabbed_slot()
	clear_displayed_characters()

func clear_displayed_characters() -> void:
	for pm: PartyMemberHolderUI in party_holder.own_pc_holder.get_children():
		pm.slot_clicked.disconnect( on_slot_clicked )
		pm.queue_free()
	for recruited: PartyMemberHolderUI in recruited_holder.own_pc_holder.get_children():
		recruited.slot_clicked.disconnect( on_slot_clicked )
		recruited.queue_free()

func on_slot_clicked(char_slot_data: PartyMemberHolderUI, index: int, button: int) -> void:
	match [grabbed_ui.stored_character, button]:
		# The player is attempting to move a character somewhere
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_ui.stored_character = char_slot_data.stored_character
			grabbed_ui.portrait.texture = char_slot_data.portrait.texture
			if PlayerPartyController.party_members.has(char_slot_data.stored_character):
				PlayerPartyController.remove_party_member( char_slot_data.stored_character )
				if OS.is_debug_build() == true:
					print("PartyManagementMenu :: Removing %s from the party." % [char_slot_data.stored_character.char_name])
			
			char_slot_data.slot_clicked.disconnect( on_slot_clicked )
			char_slot_data.queue_free()
		
		# The player wants to swap a character
		[_, MOUSE_BUTTON_LEFT]:
			# Cache the character being swapped
			var swapped_character: PlayerCombatant = char_slot_data.stored_character
			var swapped_texture                    = char_slot_data.portrait.texture
			
			# Set the new character and see if they have to be removed from the party
			char_slot_data.set_character( grabbed_ui.stored_character )
			char_slot_data.portrait.texture = grabbed_ui.portrait.texture
			if PlayerPartyController.party_members.has(swapped_character):
				var original_pos: int = PlayerPartyController.party_members.find( swapped_character )
				PlayerPartyController.remove_party_member(swapped_character)
				PlayerPartyController.add_at_index(
					char_slot_data.stored_character,
					original_pos
				)
				
				if OS.is_debug_build() == true:
					print("PartyManagementMenu :: %s was removed and replaced with: %s" % [swapped_character.char_name, char_slot_data.stored_character.char_name])				
			
			# Keep track of the character being swapped
			grabbed_ui.stored_character = swapped_character
			grabbed_ui.portrait.texture = swapped_texture
	
	update_grabbed_slot()
	
func update_grabbed_slot() -> void:
	if grabbed_ui.stored_character != null:
		grabbed_ui.global_position = get_global_mouse_position()
		grabbed_ui.show()
	else:
		grabbed_ui.hide()
