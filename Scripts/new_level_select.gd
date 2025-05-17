extends Panel

signal level_selected


var current_level : int = 0
var current_level_amount : int = 0
var city_1 : Resource = null
var city_2 : Resource = null

var randnum_1 : int = 0 
var randnum_2 : int = 0 

var is_selected : bool = false

var stage_boxes = []

const STAGE_BOX = preload("res://Scenes/stage_box2.tscn")

func _ready():
	$Panel2/HBoxContainer/StageNum.text = "#" + str(current_level + 1)
	
	#current_level = GameManager.current_level + current_level_amount
	#current_level = current_level_amount
	#level_indicator.text = "Level " + str(current_level + 1)
	##level_indicator.text = "Level " + str(GameManager.current_level)
	var num_to_pick_from = randi_range(3,3)
	
	if current_level + 1 <= Enums.LevelDifficulty.MEDIUM:
		generate_levels(GameManager.easy_cities,num_to_pick_from)
	
	elif current_level + 1 <= Enums.LevelDifficulty.HARD:
		generate_levels(GameManager.med_cities,num_to_pick_from)
		#
	elif current_level + 1 <= Enums.LevelDifficulty.EXTREME:
		generate_levels(GameManager.hard_cities,num_to_pick_from)
	else:
		generate_levels(GameManager.extreme_cities,num_to_pick_from)
	return


func generate_levels(city_array : Array, num:int):
	#var pair = generate_unique_pair(0, city_array.size() - 1)
	
	var cities_dup = city_array.duplicate(true)
	cities_dup.shuffle()
	var selected_cities = []
	
	num = min(num, cities_dup.size())
	for i in range(0,num):
		var new_city = CityInfo.new()
		var choose:CityInfo = cities_dup.pop_front()
		new_city.name = choose.name
		new_city.airport_code = choose.airport_code
		selected_cities.append(new_city)
	
	for city:CityInfo in selected_cities:
		city.roll_modifier()
		var stage_box = STAGE_BOX.instantiate()
		stage_box.set_info(city)
		stage_box.stage_select.connect(stage_selected)
		$MarginContainer/VBoxContainer.add_child(stage_box)
		stage_boxes.append(stage_box)
	
	#button.text = city_1.name + " +" + str(city_1.modifier_difficulty)
	#button_2.text = city_2.name + " +" + str(city_2.modifier_difficulty)

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

func stage_selected(sel_stage_box):
	is_selected = true
	GameManager.select_city(sel_stage_box.city)
	level_selected.emit()
	for stage_box in stage_boxes:
		if stage_box != sel_stage_box:
			stage_box.deselect()

func set_disable():
	if current_level != GameManager.current_level:
		for stage_box in stage_boxes:
			
			stage_box.lock(current_level < GameManager.current_level)
			stage_box.deselect()
	else:
		for stage_box in stage_boxes:
			stage_box.unlock()
