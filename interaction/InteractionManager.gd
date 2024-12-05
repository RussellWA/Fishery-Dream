extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label
@onready var sprite: Sprite2D = $Sprite2D

const base_text = "[E] to "

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	active_areas.push_back(area)

func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != 1:
		active_areas.remove_at(index)

func _process(delta):
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		var area_position = active_areas[0].global_position
		#sprite.global_position = active_areas[0].global_position
		sprite.global_position = Vector2(area_position.x, area_position.y + 25)
		sprite.visible = true
	else:
		sprite.visible = false
	
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			sprite.visible = false
			
			await active_areas[0].interact.call()
			can_interact = true
