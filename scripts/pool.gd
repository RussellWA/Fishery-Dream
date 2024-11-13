extends StaticBody2D

var items = [
	{"name": "Catfish", "resource": "res://hotbar/items/catfish.tres", "duration": 1},
	{"name": "Tilapia", "resource": "res://hotbar/items/tilapia.tres", "duration": 1},
	{"name": "gourami", "resource": "res://hotbar/items/gourami.tres", "duration": 2},
	{"name": "Pomfret", "resource": "res://hotbar/items/pomfret.tres", "duration": 2},
	{"name": "SnakeHead", "resource": "res://hotbar/items/snakeHead.tres" , "duration": 3},
	{"name": "SilverCatfish", "resource": "res://hotbar/items/silverCatfish.tres" , "duration": 4},
	{"name": "Belida", "resource": "res://hotbar/items/belida.tres" , "duration": 5}
]

signal updated
signal getDay
signal item_resource_send(item_resource: String)

@onready var interaction_area = $InteractionArea
@onready var click_area = $ClickArea
@export var player_hotbar_path: String = "res://hotbar/player_hotbar.tres"
@onready var hotbar: Hotbar = load(player_hotbar_path)

@onready var curr_fish: String = "empty"

var curr_day: int
var end_day: int = 0
var holdedItem: ItemGui
var isPoolEntered: bool

func _ready():
	play_anim()
	click_area.input_event.connect(_on_click_area_input_event)
	interaction_area.interact = Callable(self, "_open_ui")

func _open_ui():
	if(curr_fish != "empty" && end_day <= curr_day):
		var item_data = items.filter(func(item): return item["name"].to_lower() == curr_fish)
		var hotbar_item = item_data[0]["resource"]
		if hotbar_item:
			hotbar.insert(load(hotbar_item))
			updated.emit()
			print("Harvested")
			curr_fish = "empty"
			end_day = 0
			play_anim()
	elif(curr_fish != "empty" && curr_day != end_day):
		print(curr_fish, " Not done")
	else:
		print("empty")
		
func play_anim():
	var anim = $AnimatedSprite2D
	if curr_fish == "empty":
		anim.play("empty")
	else:
		anim.play("fish")

func _on_hotbar_gui_update_holded_item(item: ItemGui):
	if item:
		holdedItem = item
		print("test ", holdedItem.amountLabel)
		print("test ", holdedItem.itemName)
	else:
		holdedItem = null

func _on_click_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and isPoolEntered:
		if holdedItem and curr_fish == "empty":
			curr_fish = holdedItem.itemName.to_lower()
			var item_data = items.filter(func(item): return item["name"].to_lower() == curr_fish)
			print("bruh ", item_data)
			if item_data.size() > 0:
				item_resource_send.emit(item_data[0]["resource"])
				end_day = curr_day + item_data[0]["duration"]
				play_anim()

func _on_interaction_area_pool_enter(isTrue):
	isPoolEntered = isTrue

func _on_world_send_day(time):
	curr_day = time
