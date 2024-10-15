extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

@onready var hotbar = preload("res://hotbar/player_hotbar.tres")

var itemGui: ItemGui
var index: int

func insert(item: ItemGui):
	itemGui = item
	backgroundSprite.frame = 1
	container.add_child(itemGui)
	
	if !itemGui.hotbarSlot || hotbar.slots[index] == itemGui.hotbarSlot: return
	
	hotbar.insertSlot(index, itemGui.hotbarSlot)

func takeItem():
	var item = itemGui
	
	container.remove_child(itemGui)
	itemGui = null
	backgroundSprite.frame = 0
	
	return item

func isEmpty(): return !itemGui
