extends Node2D

@onready var time_label: Label = $CanvasLayer/Time
@onready var time_system: TimeSystem = $TimeSystem
@onready var night_overlay: ColorRect = $ColorRect
@onready var curr_day: int

signal sendDay(time: int)

var previous_day: int = -1

func _ready():
	# Update the time label when the scene is loaded
	update_time_label()

func _process(delta: float) -> void:
	# Continuously update the label every frame
	update_time_label()
	if curr_day != previous_day: 
		sendDay.emit(curr_day) 
		previous_day = curr_day

func update_time_label() -> void:
	# Get the hours and minutes from the DateTime instance
	var hours = time_system.date_time.hours
	var minutes = time_system.date_time.minutes
	var seconds = time_system.date_time.seconds
	
	# Format the time as "HH:MM" (e.g., 06:00)
	var time_string = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	# Update the label with the current day and time
	curr_day = time_system.date_time.days
	time_label.text = "Day " + str(curr_day) + ", " + time_string
