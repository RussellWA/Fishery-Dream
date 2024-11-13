extends Control

class_name Shop

var seeds = [
	{"name": "Catfish", "price": 2, "sprite": "res://art/items/Catfish Seed.png", "resource": "res://hotbar/seeds/catfishSeed.tres"},
	{"name": "Tilapia", "price": 2, "sprite": "res://art/items/Tilapia Seed.png", "resource": "res://hotbar/seeds/tilapiaSeed.tres"},
	{"name": "Gourami", "price": 4, "sprite": "res://art/items/Gourami Seed.png", "resource": "res://hotbar/seeds/gouramiSeed.tres"},
	{"name": "Pomfret", "price": 4, "sprite": "res://art/items/Pomfret Seed.png", "resource": "res://hotbar/seeds/pomfretSeed.tres"},
	{"name": "SnakeHead", "price": 6, "sprite": "res://art/items/Snakehead Seed.png", "resource": "res://hotbar/seeds/snakeHeadSeed.tres"},
	{"name": "SilverCatfish", "price": 8, "sprite": "res://art/items/Sliver catfish Seed.png", "resource": "res://hotbar/seeds/silverCatfishSeed.tres"},
	{"name": "Belida", "price": 10, "sprite": "res://art/items/Belida Seed.png", "resource": "res://hotbar/seeds/belidaSeed.tres"}
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
@onready var item_data = null

func _ready():
	var button = $"Buy Button"
	button.connect("pressed", buyItem)
	setShopItems()

func buyItem():
	if(item_data):
		var item_price: int = item_data["price"]
		var item_resource: Resource = load(item_data["resource"])
		var canAfford: bool = player.spend_money(item_price)
		var haveSpace: bool = hotbar.checkSlots(item_resource)
		if (canAfford && haveSpace):
			var hotbar_item = item_resource
			if hotbar_item:
				hotbar.insert(hotbar_item)

func setShopItems():
	var buttons = $NinePatchRect/GridContainer.get_children()
	
	for i in range(buttons.size()):
		var button = buttons[i]
		var item_data = seeds[i]
		
		var item_panel = button.get_node("CenterContainer").get_children()[0]
		var item_sprite = item_panel.get_children()[0]
		item_sprite.texture = load(item_data["sprite"])
		
		button.connect("pressed", displayInfo.bind(i))

func displayInfo(idx: int):
	item_data = seeds[idx]
	
	if((info_sprite.texture != null && info_label.text == item_data["name"]) || idx == -1):
		info_sprite.texture = null
		info_label.text = ""
		buy_btn.text = "Price"
		item_data = null
		return
		
	info_sprite.texture = load(item_data["sprite"])
	info_label.text = item_data["name"]
	buy_btn.text = "%d gold" % item_data["price"]

func _on_shop_button_is_open(value):
	if !value:
		displayInfo(-1)
