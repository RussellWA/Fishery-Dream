extends CharacterBody2D

@onready var money_label: Label = $"../CanvasLayer/Money"
@onready var interaction_area: InteractionArea = $InteractionArea

const speed = 100
var curr_direction = "none"

var money: int = 10

func _ready():
	
	update_money_label()
	interaction_area.interact = Callable(self, "on_interact")

func add_money(amount: int):
	print("Added money: ", amount)
	money += amount
	update_money_label()
	
func spend_money(amount: int):
	if money >= amount:
		money -= amount
		update_money_label()
		return true
	else:
		print("Not enough money")
		return false

func update_money_label():
	money_label.text = str(money)
	
func _physics_process(delta):
	player_movement(delta)
	
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		curr_direction = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		curr_direction = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		curr_direction = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("ui_down"):
		curr_direction = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func play_anim(movement):
	var direction = curr_direction
	var anim = $AnimatedSprite2D
	
	if direction == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_side")
		else:
			anim.play("idle_side")
	elif direction == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_side")
		else:
			anim.play("idle_side")
	elif direction == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_up")
		else:
			anim.play("idle_up")
	elif direction == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_down")
		else:
			anim.play("idle_down")

