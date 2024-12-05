extends Node2D

@onready var curr_node: Node2D = $"."

var cutscene = preload("res://scenes/cutscene.tscn").instantiate()
@onready var anim_player: AnimationPlayer = $CanvasLayer2/Control/AnimationPlayer
@onready var splash_sound = $Splash
@onready var titlescreen_sound = $TitleScreen

func _ready():
	anim_player.play("logo")
	splash_sound.play()
	anim_player.animation_finished.connect(title_screen)
	splash_sound.finished.connect(_on_splash_finished)
	
	$CanvasLayer/CanvasLayer/AnimatedSprite2D.play("default")
	var start_btn: Button = $CanvasLayer/StartBtn
	var exit_btn: Button = $CanvasLayer/ExitBtn
	var settings_btn: Button = $CanvasLayer/SettingsBtn
	start_btn.connect("pressed", start_game)
	settings_btn.connect("pressed", set_game)
	exit_btn.connect("pressed", exit_game)

func start_game():
	titlescreen_sound.stop()
	curr_node.call_deferred("queue_free")
	get_tree().root.add_child(cutscene)

func set_game():
	$CanvasLayer/SettingsMenu.visible = true
	$CanvasLayer/Logo.visible = false
	$CanvasLayer/StartBtn.visible = false
	$CanvasLayer/SettingsBtn.visible = false
	$CanvasLayer/ExitBtn.visible = false

func exit_game():
	get_tree().quit()

func title_screen(anim_name : String):
	$CanvasLayer2/Control/ColorRect.visible = false
	$CanvasLayer.visible = true
	$CanvasLayer/CanvasLayer.visible = true

func _on_settings_menu_back_to():
	$CanvasLayer/Logo.visible = true
	$CanvasLayer/StartBtn.visible = true
	$CanvasLayer/SettingsBtn.visible = true
	$CanvasLayer/ExitBtn.visible = true

func _on_splash_finished():
	titlescreen_sound.play()
