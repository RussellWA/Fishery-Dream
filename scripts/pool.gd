extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var click_area = $ClickArea

@onready var curr_fish: String = "empty"

var holdedItem: String

func _ready():
	play_anim()
	click_area.input_event.connect(_on_click_area_input_event)

func _toggle_pool():
	print("Pool toggled")

func play_anim():
	var anim = $AnimatedSprite2D
	anim.play("default")

func _on_hotbar_gui_update_holded_item(item: ItemGui):
	if item:
		holdedItem = item.itemName
	else:
		holdedItem = "empty"

# This function is called when there's an input event in ClickArea
func _on_click_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Mouse clicked near Pool")
		if holdedItem:
			curr_fish = holdedItem



