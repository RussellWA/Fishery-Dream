extends CanvasLayer

signal cycle_completed(isNight: bool)

@onready var color_rect = $ColorRect
@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.playback_active = true

func _on_world_cycle(isNight):
	if isNight:
		anim_player.play("day_to_night")
	elif !isNight:
		anim_player.play("night_to_day")

func _on_shop_button_pause_anim(isPaused):
	if isPaused:
		if anim_player.is_playing():
			anim_player.speed_scale = 0
	else:
		anim_player.speed_scale = 1

func _on_world_first():
	anim_player.play("first")
