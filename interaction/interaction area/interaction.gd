extends Area2D
class_name InteractionArea

signal area_enter(isTrue: bool)

@export var action_name: String = "interact"

var interact: Callable = func():
	pass

func _on_body_entered(body):
	InteractionManager.register_area(self)
	area_enter.emit(true)

func _on_body_exited(body):
	InteractionManager.unregister_area(self)
	area_enter.emit(false)
