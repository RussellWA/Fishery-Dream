extends StaticBody2D

@onready var interaction_area = $InteractionArea2
@onready var sell_gui: Control = $"../CanvasLayer/SellGui"
@onready var time_system: TimeSystem = $"../TimeSystem"
@onready var shop_btn: Button = $"../CanvasLayer/ShopButton"

var isCrateEntered: bool

func _ready():
	interaction_area.interact = Callable(self, "_open_ui")

func _on_interaction_area_2_area_enter(isTrue):
	isCrateEntered = isTrue

func _open_ui():
	if isCrateEntered:
		sell_gui.visible = true
		get_tree().paused = true
		time_system.toggle_time_pause()
		shop_btn.disabled = true
