extends Panel

class_name ItemGui

@onready var itemSprite: Sprite2D = $item
@onready var amountLabel: Label = $Label
@onready var itemName: String = "empty"

var hotbarSlot: HotbarSlot

func update():
	if !hotbarSlot || !hotbarSlot.item: return
	itemSprite.visible = true
	itemSprite.texture = hotbarSlot.item.texture
	itemName = hotbarSlot.item.name
	amountLabel.visible = true
	amountLabel.text = str(hotbarSlot.amount)
	
