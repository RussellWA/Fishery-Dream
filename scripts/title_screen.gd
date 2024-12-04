extends Node2D

@onready var curr_node: Node2D = $"."

var cutscene = preload("res://scenes/cutscene.tscn").instantiate()
@onready var anim_player: AnimationPlayer = $CanvasLayer2/Control/AnimationPlayer

func _ready():
	anim_player.play("logo")
	anim_player.animation_finished.connect(title_screen)
	
	$CanvasLayer/CanvasLayer/AnimatedSprite2D.play("default")
	var start_btn: Button = $CanvasLayer/StartBtn
	var exit_btn: Button = $CanvasLayer/ExitBtn
	start_btn.connect("pressed", start_game)
	exit_btn.connect("pressed", exit_game)

func start_game():
	curr_node.call_deferred("queue_free")
	get_tree().root.add_child(cutscene)

func exit_game():
	get_tree().quit()

func title_screen(anim_name : String):
	print("done ", anim_name)
	$CanvasLayer2/Control/ColorRect.visible = false
	$CanvasLayer.visible = true
	$CanvasLayer/CanvasLayer.visible = true
