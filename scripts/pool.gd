extends StaticBody2D

var items = [
	{"name": "Catfish", "duration": 1, "resource": "res://hotbar/items/catfish.tres", "seed": "res://hotbar/seeds/catfishSeed.tres", "image": "res://art/items/lele.png"},
	{"name": "Tilapia", "duration": 1, "resource": "res://hotbar/items/tilapia.tres", "seed": "res://hotbar/seeds/tilapiaSeed.tres", "image": "res://art/items/Nila.png"},
	{"name": "gourami", "duration": 2, "resource": "res://hotbar/items/gourami.tres", "seed": "res://hotbar/seeds/gouramiSeed.tres", "image": "res://art/items/Gurame.png"},
	{"name": "Pomfret", "duration": 2, "resource": "res://hotbar/items/pomfret.tres", "seed": "res://hotbar/seeds/pomfretSeed.tres", "image": "res://art/items/Bawal.png"},
	{"name": "SnakeHead", "duration": 3, "resource": "res://hotbar/items/snakeHead.tres", "seed": "res://hotbar/seeds/snakeHeadSeed.tres", "image": "res://art/items/Gabus.png"},
	{"name": "SilverCatfish", "duration": 4, "resource": "res://hotbar/items/silverCatfish.tres", "seed": "res://hotbar/seeds/silverCatfishSeed.tres", "image": "res://art/items/Patin.png"},
	{"name": "Belida", "duration": 5, "resource": "res://hotbar/items/belida.tres", "seed": "res://hotbar/seeds/belidaSeed.tres", "image": "res://art/items/Belida.png"}
]

signal harvest_updated
signal getDay
signal item_resource_send(item_resource: String)

@onready var interaction_area = $InteractionArea
@onready var click_area = $ClickArea
@export var player_hotbar_path: String = "res://hotbar/player_hotbar.tres"
@onready var hotbar: Hotbar = load(player_hotbar_path)
@onready var board: NinePatchRect = $Board
@onready var board2: NinePatchRect = $Board2
@onready var fishSprite: Sprite2D = $Board/FishSprite
@onready var exclam_anim: AnimatedSprite2D = $Board2/AnimatedSprite2D

@onready var curr_fish: String = "empty"

var isOpen: bool = false
var curr_day: int
var end_day: int = 0
var heldItem: ItemGui
var isPoolEntered: bool

func _ready():
	play_anim()
	click_area.input_event.connect(_on_click_area_input_event)
	interaction_area.interact = Callable(self, "_open_ui")
	get_parent().sendDay.connect(_on_world_send_day)
	hotbar.heldRemove.connect(removeHeld)
	

func _open_ui():
	if(curr_fish != "empty" and end_day <= curr_day and heldItem == null):
		var item_data = items.filter(func(item): return item["name"].to_lower() == curr_fish)
		var hotbar_item = item_data[0]
		if hotbar_item:
			var item_resource: Resource = load(hotbar_item["resource"])
			hotbar.insert(item_resource)
			print("Harvested")
			harvest_updated.emit()
			curr_fish = "empty"
			end_day = 0
			fishSprite.texture = null
			exclam_anim.stop()
			board2.visible = false
			play_anim()
	elif(curr_fish != "empty" and curr_day != end_day and heldItem == null):
		print("not yet")
		if isOpen:
			print("close")
			board.visible = false
			isOpen = false
		elif !isOpen:
			print("open")
			board.visible = true
			isOpen = true
	else:
		print(heldItem)
		print(heldItem == null)
		print("empty")
		
func play_anim():
	var anim = $AnimatedSprite2D
	if curr_fish == "empty":
		anim.play("empty")
	else:
		anim.play("fish")

func _on_hotbar_gui_update_held_item(item: ItemGui):
	print("hotbar gui ", heldItem)
	if item:
		heldItem = item
	else:
		heldItem = null

func _on_click_area_input_event(viewport: Object, event: InputEvent, shape_idx: int) -> void :
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and isPoolEntered:
		if heldItem and curr_fish == "empty": 
			if "seed" in heldItem.itemName.to_lower(): 
				var extracted_string = heldItem.itemName.to_lower().split("seed")[0]
				curr_fish = extracted_string
				var item_data = items.filter(func(item): return item["name"].to_lower() == curr_fish)
				fishSprite.texture = load(item_data[0]["image"])
				if item_data.size() > 0:
					item_resource_send.emit(item_data[0]["seed"])
					end_day = curr_day + item_data[0]["duration"]
					play_anim()
				
func _on_world_send_day(time):
	print("Pool state:", self.name, "Curr fish:", curr_fish, "Curr day:", curr_day, "End day:", end_day)
	if curr_day != time:
		curr_day = time
	board.visible = false
	if curr_fish != "empty" and curr_day >= end_day:
		exclam_anim.play("default")
		board2.visible = true
	else:
		exclam_anim.stop()
		board2.visible = false

func _on_interaction_area_area_enter(isTrue):
	isPoolEntered = isTrue

func _on_click_area_mouse_entered():
	print("Mouse entered detected")

func removeHeld():
	heldItem = null
