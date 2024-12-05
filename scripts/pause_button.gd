extends Button

signal disable(isDisable: bool)

@onready var pause_menu: Control = $"../PauseMenu"
@onready var time_system: TimeSystem = $"../../TimeSystem"
@onready var shop_btn: Button = $"../ShopButton"
@onready var shop: Control = $"../Shop"

func _ready():
	self.pressed.connect(self._button_pressed)

func _button_pressed():
	if (pause_menu.visible == false): 
		pause_menu.visible = true
		shop_btn.disabled = true
		disable.emit(true)
		get_tree().paused = true
		time_system.toggle_time_pause()
