extends Panel

signal stage_select(stage_box)

var city:CityInfo

func _ready() -> void:
	self.modulate = Color(1.0,1.0,1.0,1.0)
	var stylebox := get_theme_stylebox("panel")
	if stylebox is StyleBoxFlat:
		stylebox.shadow_size = 0

func set_info(city:CityInfo):
	$DiffMod.frame = city.modifier_difficulty
	$"HBoxContainer/Airport Code".text = city.airport_code
	
	var label = $HBoxContainer/CityName
	var label_settings = label.label_settings
	var font_size = label_settings.font_size
	var font = label_settings.font
	
	$HBoxContainer/CityName.text = city.name
	await $HBoxContainer/CityName.resized
	
	while $HBoxContainer/CityName.size.x > 130:
		font_size = font_size - 1
		label_settings.font_size = font_size
		await $HBoxContainer/CityName.resized
		
	self.city = city

func select():
	var stylebox := get_theme_stylebox("panel")
	if stylebox is StyleBoxFlat:
		stylebox.shadow_size = 6

func deselect():
	var stylebox := get_theme_stylebox("panel")
	if stylebox is StyleBoxFlat:
		stylebox.shadow_size = 0
	$Button.button_pressed = false
		
func lock():
	if $Button.disabled:
		return
	
	
	if $Button.button_pressed:
		var stylebox := get_theme_stylebox("panel")
		if stylebox is StyleBoxFlat:
			stylebox.shadow_size = 3
		self.modulate = Color.hex(0x505050FF)
	else:
		self.modulate = Color.hex(0x303030AA)
	$Button.disabled = true
	$Button.button_pressed = false
	$Button.toggle_mode = false
	$Button.visible = false
	

func unlock():
	$Button.visible = true
	$Button.disabled = false
	$Button.toggle_mode = true
	self.modulate = Color(1.0,1.0,1.0,1.0)

func _on_button_pressed() -> void:
	select()
	GameManager.selected_city = self.city
	#print("button")
	stage_select.emit(self)
	pass # Replace with function body.
