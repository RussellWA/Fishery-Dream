class_name TimeSystem extends Node

signal time_updated

@export var date_time: DateTime
@export var ticks_pr_second: float = 5000

var previous_minute: int = -1

# New variable to control if time is running
var time_paused: bool = false

func _process(delta: float) -> void:
	# Only update time if it is not paused
	if not time_paused:
		date_time.increase_by_seconds(delta * ticks_pr_second)
		
		if date_time.minutes != previous_minute:
			previous_minute = date_time.minutes
			time_updated.emit(date_time)

# Function to toggle time pause
func toggle_time_pause():
	time_paused = !time_paused
