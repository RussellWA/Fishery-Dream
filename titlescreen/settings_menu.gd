extends Control 

signal backTo()

func _ready(): 
	var resolutions = [ "Resolutions", "1280x720", "1920x1080", "2560x1440", "3840x2160" ] 
	var option_button: OptionButton = $OptionButton
	var back_button: Button = $BackButton
	back_button.connect("pressed", back_to_start)
	for res in resolutions: 
		option_button.add_item(res) 
	
	option_button.item_selected.connect(_on_OptionButton_item_selected)
	
	var slider = $Volume
	
	# Get the current volume of the audio bus
	var current_volume = AudioServer.get_bus_volume_db(0)
	
	# Set the slider range and value
	slider.min_value = -40
	slider.max_value = 20
	slider.value = current_volume
	
	# Connect the slider signal
	slider.value_changed.connect(_on_volume_value_changed)

	# Set the initial volume to the default slider value
	_on_volume_value_changed(slider.value)

func _on_OptionButton_item_selected(index): 
	if index != 0:
		var resolution = $OptionButton.get_item_text(index) 
		var res_split = resolution.split("x") 
		var width = int(res_split[0]) 
		var height = int(res_split[1]) 
		get_viewport().size = Vector2(width, height)

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

func back_to_start():
	$".".visible = false
	backTo.emit()
	
