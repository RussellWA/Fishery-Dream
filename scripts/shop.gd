extends Control

class_name Shop

var items = [
	{"name": "Catfish", "price": 2, "sprite": "res://art/items/lele.png", "resource": "res://hotbar/items/catfish.tres"},
	{"name": "Tilapia", "price": 2, "sprite": "res://art/items/Nila.png", "resource": "res://hotbar/items/tilapia.tres"},
	{"name": "Gourami", "price": 4, "sprite": "res://art/items/Gurame.png", "resource": "res://hotbar/items/gourami.tres"},
	{"name": "Pomfret", "price": 4, "sprite": "res://art/items/Bawal.png", "resource": "res://hotbar/items/pomfret.tres"},
	{"name": "Snake Head", "price": 6, "sprite": "res://art/items/Gabus.png", "resource": "res://hotbar/items/snakeHead.tres"},
	{"name": "Silver Catfish", "price": 8, "sprite": "res://art/items/Patin.png", "resource": "res://hotbar/items/silverCatfish.tres"},
	{"name": "Belida", "price": 10, "sprite": "res://art/items/Belida.png", "resource": "res://hotbar/items/belida.tres"}
]

signal opened
signal closed

signal updated

var isOpen: bool = false

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
				updated.emit()

func setShopItems():
	var buttons = $NinePatchRect/GridContainer.get_children()
	
	for i in range(buttons.size()):
		var button = buttons[i]
		var item_data = items[i]
		
		var item_panel = button.get_node("CenterContainer").get_children()[0]
		var item_sprite = item_panel.get_children()[0]
		item_sprite.texture = load(item_data["sprite"])
		
		button.connect("pressed", displayInfo.bind(i))

func displayInfo(idx: int):
	item_data = items[idx]
	
	if(info_sprite.texture != null && info_label.text == item_data["name"]):
		info_sprite.texture = null
		info_label.text = ""
		buy_btn.text = "Price"
		item_data = null
		return
		
	info_sprite.texture = load(item_data["sprite"])
	info_label.text = item_data["name"]
	buy_btn.text = "%d gold" % item_data["price"]
	

