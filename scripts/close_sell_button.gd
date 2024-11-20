extends Button

@onready var sell_gui: Control = $".."

signal unpause()

func _ready():
	self.pressed.connect(self._button_pressed)

func _button_pressed():
	sell_gui.visible = false
	get_tree().paused = false
	unpause.emit()
