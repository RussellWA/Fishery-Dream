extends Button

@onready var shop = $"../Shop"

func _ready():
	self.pressed.connect(self._button_pressed)
	#process_mode = Node.PROCESS_MODE_PAUSABLE
	#shop.process_mode = Node.PROCESS_MODE_PAUSABLE

func _button_pressed():
	if (shop.visible == false): 
		shop.visible = true
		print("Open Shop")
		get_tree().paused = true
	else: 
		print("Close Shop")
		shop.visible = false
		get_tree().paused = false
		
