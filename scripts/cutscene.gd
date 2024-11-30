extends Node2D

var video_finished = false
var world = preload("res://scenes/world.tscn").instantiate()
@onready var curr_node: Node2D = $"."
@onready var video_player: VideoStreamPlayer = $CanvasLayer/VideoStreamPlayer
@onready var label: Label = $CanvasLayer/Label

func _ready():
	video_player.play()
	video_player.connect("finished", load_world)

func load_world():
	video_finished = true
	label.text = "Press any key to continue..."
	label.visible = true

func _input(event):
	if video_finished and event.is_pressed():
		curr_node.call_deferred("queue_free")
		get_tree().root.add_child(world)
