## When the player wins a battle, this will get displayed to represent a
## party member gaining experience points.
class_name PMBattleResult extends Control

@export var char_name_label: Label

@export var level_up_time: float = 1.0

## The bar used to represent the experience.
@export var progress_bar: ProgressBar

func set_player_character(pc: PlayerCombatant) -> void:
	progress_bar.max_value = pc.experience_required
	progress_bar.value = pc.curr_experience_points
	pc.experience_gained.connect( on_experience_gained )
	char_name_label.set_text( pc.char_name )

func on_experience_gained(growth_data: Array) -> void:
	for line in growth_data:
		var desired_experience = line[0]
		var max_experience     = line[1]
		progress_bar.max_value = max_experience
		await animate_progress_bar(desired_experience, level_up_time)
		if progress_bar.max_value == progress_bar.value:
			# TODO: If we want to make a text or something to show a level up,
			# here is where we would fire it.
			progress_bar.value = progress_bar.min_value

func animate_progress_bar(target, duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", target, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
