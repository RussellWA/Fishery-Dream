extends Area2D
class_name CrateInteractionArea

signal crate_enter(isTrue: bool)

@export var action_name: String = "interact"

var interact: Callable = func():
	pass

#func _on_body_entered(body):
	#InteractionManager.crate_register_area(self)
	#crate_enter.emit(true)
#
#func _on_body_exited(body):
	#InteractionManager.crate_unregister_area(self)
	#crate_enter.emit(false)
