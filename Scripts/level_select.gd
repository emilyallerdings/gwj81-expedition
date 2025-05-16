extends Panel

@onready var level_indicator = $"Level Indicator"
@onready var button = $VBoxContainer/Button
@onready var button_2 = $VBoxContainer/Button2
@onready var v_box_container = $VBoxContainer

var current_level : int = 0
var current_level_amount : int = 0
var city_1 : Resource = null
var city_2 : Resource = null

var randnum_1 : int = 0 
var randnum_2 : int = 0 

var is_selected : bool = false

func _ready():
	#current_level = GameManager.current_level + current_level_amount
	current_level = current_level_amount
	level_indicator.text = "Level " + str(current_level + 1)
	#level_indicator.text = "Level " + str(GameManager.current_level)
	if current_level + 1 <= Enums.LevelDifficulty.MEDIUM:
		generate_levels(GameManager.easy_cities)
	
	elif current_level + 1 <= Enums.LevelDifficulty.HARD:
		generate_levels(GameManager.med_cities)
		
	elif current_level + 1 <= Enums.LevelDifficulty.EXTREME:
		generate_levels(GameManager.hard_cities)
	else:
		generate_levels(GameManager.extreme_cities)


func generate_levels(city_array : Array):
	var pair = generate_unique_pair(0, city_array.size() - 1)
	
	city_1 = city_array[pair.x]
	city_2 = city_array[pair.y]
	city_1.roll_modifier()
	city_2.roll_modifier()
	
	button.text = city_1.name + " +" + str(city_1.modifier_difficulty)
	button_2.text = city_2.name + " +" + str(city_2.modifier_difficulty)

func generate_unique_pair(min_num: int, max_num: int):
	if max_num - min_num < 1:
		push_error("generate_unique_pair() called with insufficient options")
		return Vector2(0, 0) # fallback
	
	randomize()
	randnum_1 = randi_range(min_num, max_num)
	var options := []
	for i in range(min_num, max_num + 1):
		options.append(i)
	options.erase(randnum_1)
	randnum_2 = options[randi() % options.size()]
	
	return Vector2(randnum_1, randnum_2)
	#randomize()
	#randnum_1 = randi_range(min_num, max_num)
	#var options := []
	#for i in range(min_num, max_num):
		#options.append(i)
	#options.erase(randnum_1)
	#randnum_2 = options[randi() % options.size()]
	#
	#return Vector2(randnum_1, randnum_2)

func _on_button_pressed():
	button_2.disabled = true
	is_selected = true
	GameManager.modifier_difficulty = city_1.modifier_difficulty


func _on_button_2_pressed():
	button.disabled = true
	is_selected = true
	GameManager.modifier_difficulty = city_2.modifier_difficulty


func _on_debug_pressed():
	city_1.roll_modifier()
	city_2.roll_modifier()
	
	button.text = city_1.name + " +" + str(city_1.modifier_difficulty)
	button_2.text = city_2.name + " +" + str(city_2.modifier_difficulty)
