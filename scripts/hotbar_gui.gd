extends Control

signal updated
signal update_holded_item(item: ItemGui)

@onready var hotbar: Hotbar = preload("res://hotbar/player_hotbar.tres")
@onready var itemGuiClass = preload("res://gui/item_gui.tscn")
@onready var slots: Array = $NinePatchRect/HBoxContainer.get_children()
@onready var item_data = null

@export var holdedItemResource: Resource
@export var holdedItem: ItemGui

var holdedSlot

func _ready():
	connectSlots()
	hotbar.updated.connect(update)
	update()

func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update():
	for i in range(min(hotbar.slots.size(), slots.size())):
		var hotbarSlot: HotbarSlot = hotbar.slots[i]
		if !hotbarSlot.item: 
			continue
		var itemGui: ItemGui = slots[i].itemGui
		
		print(itemGui)
		
		if !itemGui:
			itemGui = itemGuiClass.instantiate()
			slots[i].insert(itemGui)
		
		itemGui.hotbarSlot = hotbarSlot
		itemGui.update()

func onSlotClicked(slot):
	if slot.isEmpty() && holdedItem:
		insertItemToSlot(slot)
		return
	
	if !holdedItem && slot.isEmpty():
		return
	
	if !holdedItem:
		takeItemFromSlot(slot)
		
	if holdedItem && !slot.isEmpty():
		swapItems(slot)
	
func takeItemFromSlot(slot): 
	holdedItem = slot.takeItem()
	add_child(holdedItem)
	updateHoldedItem()
	update_holded_item.emit(holdedItem)

func insertItemToSlot(slot):
	var item = holdedItem
	remove_child(holdedItem)
	holdedItem = null
	slot.insert(item)
	update_holded_item.emit(null)

func updateHoldedItem():
	if !holdedItem: return
	holdedItem.global_position = get_global_mouse_position() - holdedItem.size / 2

func swapItems(slot):
	var tempItem = slot.takeItem()
	insertItemToSlot(slot)
	holdedItem = tempItem
	add_child(holdedItem)
	updateHoldedItem()

func _input(event):
	updateHoldedItem()

func _on_pool_item_resource_send(item_resource):
	holdedItemResource = load(item_resource)
	var itemAmount = int(holdedItem.amountLabel.text) - 1
	holdedItem.amountLabel.text = str(itemAmount)
	
	if itemAmount > 0:
		insertItemToSlot(holdedSlot)
	else:
		hotbar.removeSlot(holdedItemResource)
		remove_child(holdedItem)
		holdedItem = null
		update_holded_item.emit(null)
