extends Node2D

@onready var start_btn: Button = $StartBtn
@onready var curr_node: Node2D = $"."

var cutscene = preload("res://scenes/cutscene.tscn").instantiate()

func _ready():
	var start_btn: Button = $StartBtn
	start_btn.connect("pressed", start_game)

func start_game():
	curr_node.call_deferred("queue_free")
	get_tree().root.add_child(cutscene)
