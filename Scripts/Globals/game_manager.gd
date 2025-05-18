extends Node

signal generation_finished

var render_dist:float = 200

var difficulty = 5.0 # for testing my branch

var chosen_luggage : PackedScene = null
var base_difficulty : int = 0
var modifier_difficulty : int = 0
var current_level : int = 0

#In CENTS
var total_money : int = 0
var max_money : int = 99999999999
var credits : int = 0

var total_health : int = 0
var health := 0
var earned_money:int = 0

var total_total_money:int = 0
var total_total_time:float = 0

var selected_city:CityInfo = null
var current_city:CityInfo = null

var max_levels : int = 10
var easy_cities : Array[CityInfo] = []
var med_cities : Array[CityInfo] = []
var hard_cities : Array[CityInfo] = []
var extreme_cities : Array[CityInfo] = []

var map_select : PackedScene = preload("res://Scenes/map_selection.tscn")
var pause_menu_scene : PackedScene = preload("res://Scenes/pause_menu.tscn")

var map_select_loaded = null

var level_select_insts = []

var save_file:SaveFile = null

var paused : bool = false

var level_time : float = 0.0

var speed_mod:float = 0
var handling_mod:float = 0
var boost_mod:float = 0
var base_diff_mod:int = 0
var payout_mod:float = 1.0

var sfx_db : float = 0.0
var music_db : float = 0.0

func _ready():
	var dir = DirAccess.open("res://City Data/")
	var files = dir.get_files()
	
	for file in files:
		file = file.trim_suffix(".remap")
		var loaded_city = load("res://City Data/" + file)
		#print(loaded_city.name)
		#print(loaded_city.level_difficulty)
		
		var diff = loaded_city.level_difficulty
		
		if diff == loaded_city.LevelDifficulty.EASY:
			easy_cities.append(loaded_city)
		elif diff == loaded_city.LevelDifficulty.MEDIUM:
			med_cities.append(loaded_city)
		elif diff == loaded_city.LevelDifficulty.HARD:
			hard_cities.append(loaded_city)
		else:
			extreme_cities.append(loaded_city)
		
	$UI.visible = true
	map_select_loaded = map_select.instantiate()
	map_select_loaded.visible = false
	$UI.add_child(map_select_loaded)

func select_city(city:CityInfo):
	#print("Selected: ", city.name, " With Mod Dif: ", city.modifier_difficulty)
	self.selected_city = city
	modifier_difficulty = city.modifier_difficulty


func cents_to_str(amount_cents:int) -> String:
	var dollars = amount_cents / 100
	var cents = amount_cents % 100
	return "$%d.%02d" % [dollars, cents]


func reset():
	map_select_loaded.queue_free()
	map_select_loaded = map_select.instantiate()
	map_select_loaded.visible = false
	$UI.add_child(map_select_loaded)
	
	earned_money = 0
	current_level = 0
	base_difficulty = 0
	total_money = 0
	credits = 0
	total_health = 0
	chosen_luggage = null
	selected_city = null
	current_city = null
	speed_mod = 0
	handling_mod = 0
	boost_mod = 0
	base_diff_mod = 0
	payout_mod = 1.0
	total_total_money = 0
	total_total_time = 0.0

func set_luggage(luggage, luggage_scene):
	if !luggage:
		return
		
	chosen_luggage = luggage_scene
	total_health = luggage.health
	health = total_health

func _process(delta):
	if Input.is_action_just_pressed("pause") \
	and not get_tree().root.has_node("Main Menu") \
	and not get_tree().root.has_node("Game Over Screen") \
	and not get_tree().root.has_node("Transition Screen"):
		var pause_menu := pause_menu_scene.instantiate()
		get_tree().root.add_child(pause_menu)
		get_tree().paused = true
