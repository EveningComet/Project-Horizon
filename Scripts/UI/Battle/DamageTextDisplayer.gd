## Handles displaying how much damage was taken in the battle scene.
class_name DamageTextDisplayer extends Label

@export var y_change: float = 30.0
@export var floating_duration: float = 1.0

func display(dmg_amt: int) -> void:
	show()
	text = str(dmg_amt)
	
	# Use a tween to animate the text
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		self, "global_position:y", global_position.y - y_change, floating_duration
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self, "modulate:a", 0, floating_duration
	).set_ease(Tween.EASE_IN)
	
	await tween.finished
	queue_free()
