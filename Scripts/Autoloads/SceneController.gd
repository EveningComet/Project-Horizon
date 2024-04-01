## The class here is responsible for switching between scenes.

extends Node

var loading_screen_scene = preload("res://Scenes/UI/Loading Screen/Loading Screen.tscn")
var current_scene = null

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child( root.get_child_count() - 1)

## Used to change to a new scene. The new scene will be queued to load to prevent
## weird stuff from happening.
func switch_to_scene(scene_path: String) -> void:
	call_deferred("_deferred_switch", scene_path)

func _deferred_switch(scene_path: String) -> void:
	# Remove the old scene, then load up the new scene
	current_scene.queue_free()
	var s = ResourceLoader.load( scene_path )
	current_scene = s.instantiate()
	
	# Add the scene to the active scene as a child of root
	get_tree().root.add_child( current_scene )
