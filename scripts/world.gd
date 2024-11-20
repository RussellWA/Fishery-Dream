extends Node2D

signal fade(isTrue: bool)
signal sendDay(time: int)
signal changeDay(day: int, hour: int, minute: int)

# Canvas Layers
@onready var trans_scene: CanvasLayer = $CanvasLayer/TransitionScene
@onready var time_gui = $CanvasLayer/TimeGui
@onready var time_system: TimeSystem = $TimeSystem
#@onready var gold: Sprite2D = $CanvasLayer/Gold
#@onready var money_label: Label = $CanvasLayer/Money
#@onready var hotbar_gui = $CanvasLayer/HotbarGui
#@onready var shop = $CanvasLayer/Shop
#@onready var shopBtn = $CanvasLayer/ShopButton

@onready var curr_day: int

var has_transitioned: bool = false

var previous_day: int = -1

func _ready():
	# Update the time label when the scene is loaded
	update_time_label()
	
func _process(delta: float) -> void:
	# Continuously update the label every frame
	update_time_label()
	
	if time_system.date_time.hours == 23 and time_system.date_time.minutes == 59 and not has_transitioned:
		transition()
		has_transitioned = true

func update_time_label() -> void:
	# Get the hours and minutes from the DateTime instance
	var hours = time_system.date_time.hours
	var minutes = time_system.date_time.minutes
	var seconds = time_system.date_time.seconds
	
	# Format the time as "HH:MM" (e.g., 06:00)
	var time_string = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	# Update the label with the current day and time
	curr_day = time_system.date_time.days

func transition() -> void:
	time_system.toggle_time_pause()
	get_tree().paused = true
	fade.emit(true)

func _on_transition_scene_fade_completed(isBlack):
	if isBlack:
		time_system.date_time.days += 1
		time_system.date_time.hours = 6
		time_system.date_time.minutes = 0
		var day = curr_day + 1
		if curr_day != previous_day: 
			sendDay.emit(curr_day) 
			previous_day = curr_day
		changeDay.emit(day, 6, 0)
		fade.emit(false)
	else:
		time_system.toggle_time_pause()
		get_tree().paused = false
		has_transitioned = false

func _on_house_sleep():
	transition()
