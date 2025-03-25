extends Resource

class_name Hotbar

signal updated
signal heldRemove

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
		if slots[i] != null and slots[i].item != null and slots[i].item == item:
			removeItemAtIndex(i)

func removeByName(name: String):
	print("remove ", name)
	for i in range(slots.size()):
		print("idx ", i);
		if slots[i] != null and slots[i].item != null and slots[i].item.name.to_lower() == name:
			removeItemAtIndex(i)
			return
		#elif slots[i] != null and slots[i].item != null:
			#print("item name: ", slots[i].item.name)
		#elif slots[i] == null:
			#print("slot null")
		#elif slots[i].item == null:
			#print("item null")
			

func insert(item: HotbarItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	updated.emit()

func reduceAmount(item: HotbarItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	itemSlots[0].amount -= 1

func removeItemAtIndex(index: int):
	print("removing")
	slots[index] = HotbarSlot.new()
	heldRemove.emit()

func insertSlot(index: int, hotbarSlot: HotbarSlot):
	var oldIndex: int = slots.find(hotbarSlot)
	removeItemAtIndex(oldIndex)
	slots[index] = hotbarSlot
