extends Control

@onready var time_system: TimeSystem = $"../../TimeSystem"
@onready var slots: Array = $NinePatchRect/HBoxContainer.get_children()
@onready var itemGuiClass = preload("res://gui/item_gui.tscn")
@onready var player: CharacterBody2D = get_node("../../player")
@onready var shop_btn: Button = $"../ShopButton"

var fishes = [
	{"name": "Catfish", "price": 2},
	{"name": "Tilapia", "price": 2},
	{"name": "Gourami", "price": 4},
	{"name": "Pomfret", "price": 4},
	{"name": "SnakeHead", "price": 6},
	{"name": "SilverCatfish", "price": 8},
	{"name": "Belida", "price": 10}
]

signal get_held_item(slot)
signal item_sold()

var heldItem: ItemGui = null

func _ready():
	connect_slots()

func connect_slots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		var callable = Callable(on_slot_clicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func on_slot_clicked(slot):
	get_held_item.emit(slot)

func insert_item_to_slot(slot):
	var item = heldItem
	var fish_data = fishes.filter(func(fish): return fish["name"].to_lower() == item.itemName.to_lower())
	player.add_money(fish_data[0]["price"] * 1.5)
	item_sold.emit()

func _on_hotbar_gui_sell_held_item(slot, item):
	heldItem = item
	
	if "seed" in heldItem.itemName.to_lower():
		return
	
	if slot.isEmpty() and heldItem:
		insert_item_to_slot(slot)
		return
	
	if !heldItem and slot.isEmpty():
		return

func _on_close_button_unpause():
	time_system.toggle_time_pause()
	shop_btn.disabled = false
