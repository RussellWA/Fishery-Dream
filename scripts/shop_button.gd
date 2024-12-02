extends Button

@onready var shop = $"../Shop"
@onready var time_system: TimeSystem = $"../../TimeSystem"

signal pause_anim(isPaused: bool)

func _ready():
	self.pressed.connect(self._button_pressed)

func _button_pressed():
	if (shop.visible == false): 
		shop.visible = true
		get_tree().paused = true
		pause_anim.emit(true)
		time_system.toggle_time_pause()
	else: 
		shop.visible = false
		get_tree().paused = false
		pause_anim.emit(false)
		time_system.toggle_time_pause()
		
