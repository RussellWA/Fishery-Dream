extends Button

@onready var shop = $"../Shop"
@onready var time_system: TimeSystem = $"../../TimeSystem"

func _ready():
	self.pressed.connect(self._button_pressed)

func _button_pressed():
	if (shop.visible == false): 
		shop.visible = true
		print("Open Shop")
		get_tree().paused = true
		time_system.toggle_time_pause()
	else: 
		print("Close Shop")
		shop.visible = false
		get_tree().paused = false
		time_system.toggle_time_pause()
		
