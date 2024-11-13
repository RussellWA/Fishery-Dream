extends Resource

class_name Hotbar

signal updated

@export var slots: Array[HotbarSlot]
@export var hotbar_path: String = "res://hotbar/player_hotbar.tres"

func checkSlots(item: HotbarItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	
	if !itemSlots.is_empty():
		return true

	var emptySlots = slots.filter(func(slot): return slot.item == null)
	if !emptySlots.is_empty():
		return true
	return false

func removeSlot(item: HotbarItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	for i in range(slots.size()): 
		if slots[i].item == item:
			removeItemAtIndex(i)

func insert(item: HotbarItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
			print(emptySlots[0].item, ": ", emptySlots[0].amount)
	updated.emit()

func removeItemAtIndex(index: int):
	slots[index] = HotbarSlot.new()

func insertSlot(index: int, hotbarSlot: HotbarSlot):
	var oldIndex: int = slots.find(hotbarSlot)
	removeItemAtIndex(oldIndex)
	slots[index] = hotbarSlot
