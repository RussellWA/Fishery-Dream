extends CanvasLayer

signal cycle_completed(isNight: bool)

@onready var color_rect = $ColorRect
@onready var anim_player = $AnimationPlayer

func _ready():
	color_rect.visible = false
	anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name): 
	if anim_name == "day_to_night": 
		cycle_completed.emit(true)

func _on_world_cycle(isNight):
	if isNight:
		color_rect.visible = true
		anim_player.play("day_to_night")
	elif !isNight:
		anim_player.play("night_to_day")
