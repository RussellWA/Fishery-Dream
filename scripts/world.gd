extends Node2D

signal fade(isTrue: bool)
signal cycle(isNight: bool)
signal sendDay(time: int)
signal changeDay(day: int, hour: int, minute: int)
signal morning()
signal first()
signal playerLookDown()
signal doneLoading()
signal lightOn(isOn: bool)

# Canvas Layers
@onready var trans_scene: CanvasLayer = $CanvasLayer/TransitionScene
@onready var time_gui = $CanvasLayer/TimeGui
@onready var time_system: TimeSystem = $TimeSystem
@onready var day_music: AudioStreamPlayer2D = $DayMusic
@onready var night_music: AudioStreamPlayer2D = $NightMusic

@onready var fade_out_music = create_tween()
@onready var curr_day: int
@export var transition_duration = 1.00
@export var transition_type = 1

var has_transitioned: bool = false
var first_cycle: bool = true
var previous_day: int = -1
var house_location: Vector2
var isLoading: bool = false

func _ready():
	if first_cycle:
		first_cycle = false
		first.emit()
		day_music.play()
	update_time_label()
	$player.global_position = $house.global_position + Vector2(0, 10)
	
func _process(delta: float) -> void:
	update_time_label()
	day_music.process_mode = Node.PROCESS_MODE_ALWAYS
	night_music.process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer/day_night.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if time_system.date_time.hours == 23 and time_system.date_time.minutes == 59 and not has_transitioned:
		transition()
		has_transitioned = true
	
	if time_system.date_time.hours == 18 and time_system.date_time.minutes == 0 and not has_transitioned:
		day_music.stop()
		night_music.play()
		cycle.emit(true)
		lightOn.emit(true)
	
	if time_system.date_time.hours == 7 and time_system.date_time.minutes == 30 and not has_transitioned:
		lightOn.emit(false)
		cycle.emit(false)

func update_time_label() -> void:
	var hours = time_system.date_time.hours
	var minutes = time_system.date_time.minutes
	var seconds = time_system.date_time.seconds
	
	var time_string = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	curr_day = time_system.date_time.days

func transition() -> void:
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
		$player.global_position = $house.global_position + Vector2(0, 20)
		lightOn.emit(true)
		playerLookDown.emit()
		doneLoading.emit()
		night_music.stop()
		day_music.play()
	else:
		time_system.toggle_time_pause()
		get_tree().paused = false
		has_transitioned = false
		first.emit()
		$CanvasLayer/CanvasLayer.visible = false

func _on_house_sleep():
	transition()

func _on_done_loading():
	print("done")
	fade.emit(false)
