extends CanvasLayer

signal fade_completed(isBlack: bool)

@onready var color_rect = $ColorRect
@onready var anim_player = $AnimationPlayer

func _ready():
	color_rect.visible = false
	anim_player.animation_finished.connect(_on_animation_finished)

func _on_world_fade(isTrue):
	if isTrue:
		color_rect.visible = true
		anim_player.play("fade_to_black")
	elif !isTrue:
		anim_player.play("fade_to_normal")

func _on_animation_finished(anim_name): 
	if anim_name == "fade_to_black": 
		fade_completed.emit(true) 
	if anim_name == "fade_to_normal": 
		color_rect.visible = false
		fade_completed.emit(false) 
