extends Node2D

signal fade(isTrue: bool)
signal cycle(isNight: bool)
signal sendDay(time: int)
signal changeDay(day: int, hour: int, minute: int)
signal morning()
signal first()

# Canvas Layers
@onready var trans_scene: CanvasLayer = $CanvasLayer/TransitionScene
@onready var time_gui = $CanvasLayer/TimeGui
@onready var time_system: TimeSystem = $TimeSystem

@onready var curr_day: int

var has_transitioned: bool = false
var first_cycle: bool = true
var previous_day: int = -1

func _ready():
	if first_cycle:
		first_cycle = false
		first.emit()
	update_time_label()
	
func _process(delta: float) -> void:
	update_time_label()
	
	if time_system.date_time.hours == 23 and time_system.date_time.minutes == 59 and not has_transitioned:
		transition()
		print("Transition triggered at 23:59") 
		has_transitioned = true
	
	if time_system.date_time.hours == 18 and time_system.date_time.minutes == 0 and not has_transitioned:
		cycle.emit(true)
	
	if time_system.date_time.hours == 7 and time_system.date_time.minutes == 30 and not has_transitioned:
		cycle.emit(false)

func update_time_label() -> void:
	var hours = time_system.date_time.hours
	var minutes = time_system.date_time.minutes
	var seconds = time_system.date_time.seconds
	
	var time_string = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	curr_day = time_system.date_time.days

func transition() -> void:
	print("change day")
	morning.emit()
	time_system.toggle_time_pause()
	get_tree().paused = true
	fade.emit(true)

func _on_transition_scene_fade_completed(isBlack):
	if isBlack:
		$CanvasLayer/CanvasLayer.visible = true
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
		first.emit()
		$CanvasLayer/CanvasLayer.visible = false

func _on_house_sleep():
	transition()
