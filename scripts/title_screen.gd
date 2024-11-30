extends Node2D

@onready var curr_node: Node2D = $"."

var cutscene = preload("res://scenes/cutscene.tscn").instantiate()

func _ready():
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
