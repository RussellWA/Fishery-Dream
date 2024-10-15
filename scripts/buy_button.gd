extends Button

signal updated

@export var player_hotbar_path: String = "res://hotbar/player_hotbar.tres"

@onready var player: CharacterBody2D = get_node("../../player")

@onready var hotbar: Hotbar = load(player_hotbar_path)

#@export var item: String = "res://hotbar/items/catfish.tres"

func _ready():
	button.pressed.connect(self._button_pressed)

func _button_pressed():
	#var canAfford: bool = player.spend_money(3)
	#if canAfford:
		#var hotbar_item = load(item)
		#if hotbar_item:
			#hotbar.insert(hotbar_item)
			#updated.emit()
	print("lol")
			
