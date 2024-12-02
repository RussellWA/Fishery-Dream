extends Control

class_name Shop

var seeds = [
	{"name": "Catfish", "price": 2, "sprite": "res://art/items/Catfish Seed.png", "fish": "res://art/items/lele.png", "resource": "res://hotbar/seeds/catfishSeed.tres", "isLocked": false},
	{"name": "Tilapia", "price": 2, "sprite": "res://art/items/Tilapia Seed.png", "fish": "res://art/items/Nila.png", "resource": "res://hotbar/seeds/tilapiaSeed.tres", "isLocked": true},
	{"name": "Gourami", "price": 4, "sprite": "res://art/items/Gourami Seed.png", "fish": "res://art/items/Gurame.png", "resource": "res://hotbar/seeds/gouramiSeed.tres", "isLocked": true},
	{"name": "Pomfret", "price": 4, "sprite": "res://art/items/Pomfret Seed.png", "fish": "res://art/items/Bawal.png", "resource": "res://hotbar/seeds/pomfretSeed.tres", "isLocked": true},
	{"name": "SnakeHead", "price": 6, "sprite": "res://art/items/Snakehead Seed.png", "fish": "res://art/items/Gabus.png", "resource": "res://hotbar/seeds/snakeHeadSeed.tres", "isLocked": true},
	{"name": "SilverCatfish", "price": 8, "sprite": "res://art/items/Sliver catfish Seed.png", "fish": "res://art/items/Patin.png", "resource": "res://hotbar/seeds/silverCatfishSeed.tres", "isLocked": true},
	{"name": "Belida", "price": 10, "sprite": "res://art/items/Belida Seed.png", "fish": "res://art/items/Belida.png", "resource": "res://hotbar/seeds/belidaSeed.tres", "isLocked": true}
]

signal opened
signal closed

signal updated

@export var player_hotbar_path: String = "res://hotbar/player_hotbar.tres"
@onready var hotbar: Hotbar = load(player_hotbar_path)
@onready var player: CharacterBody2D = get_node("../../player")

@onready var info_sprite: Sprite2D = $Info/NinePatchRect/item
@onready var info_label: Label = $Info/name
@onready var buy_btn: Button = $"Buy Button"
@onready var buy_sprite: Sprite2D = $"Buy Button/Buy"
@onready var locked_sprite: Sprite2D = $"Buy Button/Locked"
@onready var price_label: Label = $Info/price
@onready var coin_sprite: Sprite2D = $Info/coin
@onready var item_data = null

func _ready():
	var button = $"Buy Button"
	button.connect("pressed", buyItem)
	setShopItems()

func buyItem():
	if(item_data and !item_data["isLocked"]):
		var item_price: int = item_data["price"]
		var item_resource: Resource = load(item_data["resource"])
		var canAfford: bool = player.spend_money(item_price)
		var haveSpace: bool = hotbar.checkSlots(item_resource)
		if (canAfford and haveSpace):
			var hotbar_item = item_resource
			if hotbar_item:
				hotbar.insert(hotbar_item)
	elif(item_data and item_data["isLocked"]):
		print(item_data["name"], " Locked")

func setShopItems():
	var buttons = $NinePatchRect/GridContainer.get_children()
	
	for i in range(buttons.size()):
		var button = buttons[i]
		var item_data = seeds[i]
		
		var item_panel = button.get_node("CenterContainer").get_children()[0]
		var item_sprite = item_panel.get_children()[0]
		item_sprite.texture = load(item_data["sprite"])
		
		var item_locked = item_panel.get_children()[1]
		
		if item_data["isLocked"]:
			item_locked.visible = true
		else:
			item_locked.visible = false
		
		button.connect("pressed", displayInfo.bind(i))

func displayInfo(idx: int):
	item_data = seeds[idx]
	if(item_data["isLocked"]):
		buy_sprite.visible = false
		locked_sprite.visible = true
	else:
		buy_sprite.visible = true
		locked_sprite.visible = false
	
	if((info_sprite.texture != null and info_label.text == item_data["name"]) || idx == -1):
		info_sprite.texture = null
		info_label.text = ""
		price_label.text = ""
		#buy_btn.text = "Price"
		item_data = null
		coin_sprite.visible = false
		return
		
		
	info_sprite.texture = load(item_data["fish"])
	info_label.text = item_data["name"]
	price_label.text = str(item_data["price"])
	coin_sprite.visible = true
	#buy_btn.text = "%d gold" % item_data["price"]

func _on_shop_button_is_open(value):
	if !value:
		displayInfo(-1)

func _on_player_unlock_fish(fish):
	print("Unlock ", fish);
	for seed in seeds:
		if seed["name"] == fish:
			seed["isLocked"] = false
			setShopItems()
			return
