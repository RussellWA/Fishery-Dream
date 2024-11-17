extends StaticBody2D

var items = [
	{"name": "Catfish", "duration": 1, "resource": "res://hotbar/items/catfish.tres", "seed": "res://hotbar/seeds/catfishSeed.tres"},
	{"name": "Tilapia", "duration": 1, "resource": "res://hotbar/items/tilapia.tres", "seed": "res://hotbar/seeds/tilapiaSeed.tres"},
	{"name": "gourami", "duration": 2, "resource": "res://hotbar/items/gourami.tres", "seed": "res://hotbar/seeds/gouramiSeed.tres"},
	{"name": "Pomfret", "duration": 2, "resource": "res://hotbar/items/pomfret.tres", "seed": "res://hotbar/seeds/pomfretSeed.tres"},
	{"name": "SnakeHead", "duration": 3, "resource": "res://hotbar/items/snakeHead.tres", "seed": "res://hotbar/seeds/snakeHeadSeed.tres"},
	{"name": "SilverCatfish", "duration": 4, "resource": "res://hotbar/items/silverCatfish.tres", "seed": "res://hotbar/seeds/silverCatfishSeed.tres"},
	{"name": "Belida", "duration": 5, "resource": "res://hotbar/items/belida.tres", "seed": "res://hotbar/seeds/belidaSeed.tres"}
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
	if(curr_fish != "empty" and end_day <= curr_day):
		var item_data = items.filter(func(item): return item["name"].to_lower() == curr_fish)
		var hotbar_item = item_data[0]["resource"]
		if hotbar_item:
			hotbar.insert(load(hotbar_item))
			updated.emit()
			print("Harvested")
			curr_fish = "empty"
			end_day = 0
			play_anim()
	elif(curr_fish != "empty" and curr_day != end_day):
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
	else:
		holdedItem = null

func _on_click_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and isPoolEntered:
		if holdedItem and curr_fish == "empty":
			var extracted_string = holdedItem.itemName.to_lower().split("seed")[0]
			curr_fish = extracted_string
			var item_data = items.filter(func(item): return item["name"].to_lower() == curr_fish)
			if item_data.size() > 0:
				item_resource_send.emit(item_data[0]["seed"])
				end_day = curr_day + item_data[0]["duration"]
				play_anim()

func _on_interaction_area_pool_enter(isTrue):
	isPoolEntered = isTrue

func _on_world_send_day(time):
	curr_day = time
