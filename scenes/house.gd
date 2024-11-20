extends StaticBody2D

@onready var interaction_area = $InteractionArea2

signal sleep

func _ready():
	interaction_area.interact = Callable(self, "_open_ui")

func _open_ui():
	print("Sleep")
	sleep.emit()
