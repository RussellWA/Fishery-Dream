extends Control

signal updated
signal update_held_item(item: ItemGui)
signal sell_held_item(slot, item: ItemGui)

@onready var hotbar: Hotbar = preload("res://hotbar/player_hotbar.tres")
@onready var itemGuiClass = preload("res://gui/item_gui.tscn")
@onready var slots: Array = $NinePatchRect/HBoxContainer.get_children()
@onready var item_data = null

@export var heldItemResource: Resource
@export var heldItem: ItemGui

var heldSlot

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
		
		if !itemGui:
			itemGui = itemGuiClass.instantiate()
			slots[i].insert(itemGui)
		
		itemGui.hotbarSlot = hotbarSlot
		itemGui.update()

func onSlotClicked(slot):
	if slot.isEmpty() and heldItem:
		insertItemToSlot(slot)
		return
	
	if !heldItem and slot.isEmpty():
		return
	
	if !heldItem:
		takeItemFromSlot(slot)
		
	if heldItem and !slot.isEmpty():
		swapItems(slot)
	
func takeItemFromSlot(slot): 
	heldItem = slot.takeItem()
	add_child(heldItem)
	updateheldItem()
	update_held_item.emit(heldItem)

func insertItemToSlot(slot):
	var item = heldItem
	remove_child(heldItem)
	heldItem = null
	slot.insert(item)
	update_held_item.emit(null)

func updateheldItem():
	if !heldItem: return
	heldItem.global_position = get_global_mouse_position() - heldItem.size / 2

func swapItems(slot):
	var tempItem = slot.takeItem()
	insertItemToSlot(slot)
	heldItem = tempItem
	add_child(heldItem)
	updateheldItem()

func _input(event):
	updateheldItem()

func _on_pool_item_resource_send(item_resource):
	heldItemResource = load(item_resource)
	var itemAmount = int(heldItem.amountLabel.text) - 1
	heldItem.amountLabel.text = str(itemAmount)
	if itemAmount > 0:
		hotbar.reduceAmount(heldItemResource)
	else:
		hotbar.removeSlot(heldItemResource)
		remove_child(heldItem)
		heldItem = null
		update_held_item.emit(null)

func _on_sell_gui_get_held_item(slot):
	sell_held_item.emit(slot, heldItem)

func _on_sell_gui_item_sold():
	heldItem = null

func _on_pool_harvest_updated():
	update()
