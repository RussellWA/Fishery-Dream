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
@onready var day_music: AudioStreamPlayer2D = $DayMusic
@onready var night_music: AudioStreamPlayer2D = $NightMusic

@onready var fade_out_music = create_tween()
@onready var curr_day: int
@export var transition_duration = 1.00
@export var transition_type = 1

var has_transitioned: bool = false
var first_cycle: bool = true
var previous_day: int = -1

func _ready():
	if first_cycle:
		first_cycle = false
		first.emit()
		day_music.play()
	update_time_label()
	
func _process(delta: float) -> void:
	update_time_label()
	day_music.process_mode = Node.PROCESS_MODE_ALWAYS
	night_music.process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer/day_night.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if time_system.date_time.hours == 23 and time_system.date_time.minutes == 59 and not has_transitioned:
		transition()
		has_transitioned = true
	
	#if time_system.date_time.hours == 10 and time_system.date_time.minutes == 0 and not has_transitioned:
		#fade_out(day_music)
	
	if time_system.date_time.hours == 18 and time_system.date_time.minutes == 0 and not has_transitioned:
		day_music.stop()
		night_music.play()
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

#func fade_out(stream_player):
	#print("player: ", stream_player)
	#fade_out_music.tween_property(stream_player, "volume_db", linear_to_db(1.0), 1.0).from(linear_to_db(0.1))
	#fade_out_music.play()
#
#func _on_Tween_tween_completed(object, key):
	#object.stop()
	#object.volume_db = 0 # reset volume
