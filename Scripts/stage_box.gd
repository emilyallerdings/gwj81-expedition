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
	var font: Font = $HBoxContainer/CityName.get_theme_font("font")
	var font_size: int = $HBoxContainer/CityName.get_theme_font_size("font")
	var text_size: Vector2 = font.get_string_size(city.name, HORIZONTAL_ALIGNMENT_LEFT, font_size)
	var text_width: float = text_size.x
	print(text_width)
	$HBoxContainer/CityName.text = city.name
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
	$Button.disabled = true
	if $Button.button_pressed:
		self.modulate = Color.hex(0x505050FF)
	else:
		self.modulate = Color.hex(0x303030AA)

func unlock():
	$Button.disabled = false
	self.modulate = Color(1.0,1.0,1.0,1.0)

func _on_button_pressed() -> void:
	select()
	GameManager.selected_city = self.city
	print("button")
	stage_select.emit(self)
	pass # Replace with function body.
