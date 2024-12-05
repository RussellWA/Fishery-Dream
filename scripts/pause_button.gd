extends Button

@onready var pause_menu: Control = $"../PauseMenu"
@onready var time_system: TimeSystem = $"../../TimeSystem"
@onready var shop_btn: Button = $"../ShopButton"

func _ready():
	self.pressed.connect(self._button_pressed)

func _button_pressed():
	if (pause_menu.visible == false): 
		pause_menu.visible = true
		shop_btn.disabled = true
		get_tree().paused = true
		time_system.toggle_time_pause()
