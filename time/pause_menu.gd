extends Control

signal disable(isDisable: bool)

@onready var continue_btn: Button = $ContinueBtn
@onready var exit_btn: Button = $ExitBtn
@onready var settings_btn: Button = $SettingsBtn
@onready var time_system: TimeSystem = $"../../TimeSystem"
@onready var shop_btn: Button = $"../ShopButton"

func _ready():
	continue_btn.pressed.connect(_continue_button_pressed)
	settings_btn.pressed.connect(_settings_button_pressed)
	exit_btn.pressed.connect(_exit_button_pressed)

func _continue_button_pressed():
	get_tree().paused = false
	time_system.toggle_time_pause()
	shop_btn.disabled = false
	$".".visible = false
	$"../PauseButton".disabled = false
	disable.emit(false)

func _settings_button_pressed():
	$".".visible = false
	$"../SettingsMenu".visible = true
	$"../SettingsBkg".visible = true
	$"../PauseButton".disabled = true

func _exit_button_pressed():
	get_tree().quit()

func _on_settings_menu_back_to():
	$".".visible = true
	$"../SettingsMenu".visible = false
	$"../SettingsBkg".visible = false
