extends Node

var difficulty = 5.0 # for testing my branch

var chosen_luggage : PackedScene = null
var base_difficulty : int = 0
var modifier_difficulty : int = 0
var current_level : int = 0
var starting_money : float = 100.0
var credits : int = 0

var max_levels : int = 10
var easy_cities : Array[CityInfo] = []
var med_cities : Array[CityInfo] = []
var hard_cities : Array[CityInfo] = []
var extreme_cities : Array[CityInfo] = []

var map_select : PackedScene = preload("res://Scenes/map_selection.tscn")

func _ready():
	var dir = DirAccess.open("res://City Data/")
	var files = dir.get_files()
	
	for file in files:
		file = file.trim_suffix(".remap")
		var loaded_city = load("res://City Data/" + file)
		print(loaded_city.name)
		print(loaded_city.level_difficulty)
		
		var diff = loaded_city.level_difficulty
		
		if diff == loaded_city.LevelDifficulty.EASY:
			easy_cities.append(loaded_city)
		elif diff == loaded_city.LevelDifficulty.MEDIUM:
			med_cities.append(loaded_city)
		elif diff == loaded_city.LevelDifficulty.HARD:
			hard_cities.append(loaded_city)
		else:
			extreme_cities.append(loaded_city)
		
		#if diff == Enums.LevelDifficulty.EASY:
			#easy_cities.append(loaded_city)
		#elif diff == Enums.LevelDifficulty.MEDIUM:
			#med_cities.append(loaded_city)
		#elif diff == Enums.LevelDifficulty.HARD:
			#hard_cities.append(loaded_city)
		#else:
			#extreme_cities.append(loaded_city)
	
	#print(Enums.LevelDifficulty.EASY)
	#print(Enums.LevelDifficulty.MEDIUM)
	#print(Enums.LevelDifficulty.HARD)
	#print(Enums.LevelDifficulty.EXTREME)
#func _process(delta):
	#print("Current difficulty: " + str(GameManager.base_difficulty))
	#print("Current level: " + str(GameManager.current_level))
