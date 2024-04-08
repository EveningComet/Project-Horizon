extends Control

@export var level_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	set_level_label(MissionController.get_current_level())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_level_label(level: int) -> void:
	level_label.text = "Level: " + str(level)
	
