extends Control

@onready var days_label: Label = $DayControl/days
@onready var hours_label: Label = $ClockBG/ClockControl/hours
@onready var minutes_label: Label = $ClockBG/ClockControl/minutes
@onready var sun: Sprite2D = $DayControl/sun
@onready var moon: Sprite2D = $DayControl/moon

func _on_time_system_time_updated(date_time: DateTime) -> void:
	update_label(days_label, date_time.days, false)
	update_label(hours_label, date_time.hours)
	update_label(minutes_label, date_time.minutes)
	update_icon(date_time.hours)

func add_leading_zero(label: Label, value: int) -> void:
	if value < 10:
		label.text += '0'

func update_label(label: Label, value: int, should_have_zero: bool = true) -> void:
	label.text = ""
	
	if should_have_zero:
		add_leading_zero(label, value)
	
	label.text += str(value)

func update_icon(hour: int):
	if hour >= 18:
		sun.visible = false
		moon.visible = true
	elif hour >= 6 and hour <= 17:
		sun.visible = true
		moon.visible = false


func _on_world_change_day(day, hour, minute):
	update_label(days_label, day, false)
	update_label(hours_label, hour)
	update_label(minutes_label, minute)
	update_icon(hour)
