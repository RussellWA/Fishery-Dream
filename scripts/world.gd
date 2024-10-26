extends Node2D

@onready var time_label: Label = $CanvasLayer/Time
@onready var time_system: TimeSystem = $TimeSystem
@onready var night_overlay: ColorRect = $ColorRect

func _ready():
	# Update the time label when the scene is loaded
	update_time_label()

func _process(delta: float) -> void:
	# Continuously update the label every frame
	update_time_label()

func update_time_label() -> void:
	# Get the hours and minutes from the DateTime instance
	var hours = time_system.date_time.hours
	var minutes = time_system.date_time.minutes
	var seconds = time_system.date_time.seconds
	
	# Format the time as "HH:MM" (e.g., 06:00)
	var time_string = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	# Update the label with the current day and time
	time_label.text = "Day " + str(time_system.date_time.days) + ", " + time_string

