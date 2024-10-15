extends Control

signal updated

@onready var hotbar: Hotbar = preload("res://hotbar/player_hotbar.tres")
@onready var itemGuiClass = preload("res://gui/item_gui.tscn")
@onready var slots: Array = $NinePatchRect/HBoxContainer.get_children()

var takenItem: ItemGui

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
	if slot.isEmpty() && takenItem:
		insertItemToSlot(slot)
		return
	
	if !takenItem && slot.isEmpty():
		return
	
	if !takenItem:
		takeItemFromSlot(slot)
	
	
func takeItemFromSlot(slot):
	takenItem = slot.takeItem()
	add_child(takenItem)
	updateTakenItem()

func insertItemToSlot(slot):
	var item = takenItem
	remove_child(takenItem)
	takenItem = null
	slot.insert(item)

func updateTakenItem():
	if !takenItem: return
	takenItem.global_position = get_global_mouse_position() - takenItem.size / 2
	
func _input(event):
	updateTakenItem()
