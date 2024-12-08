extends StaticBody2D

func _on_world_light_on(isOn):
	if isOn:
		$PointLight2D.visible = true
	else:
		$PointLight2D.visible = false
