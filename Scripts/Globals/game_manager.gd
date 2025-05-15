extends Node

var chosen_luggage : PackedScene = null
var base_difficulty : int = 1
var modifier_difficulty : int = 0
var current_level : int = 5
var starting_money : float = 100.0
var credits : int = 0

var max_levels : int = 10
var easy_cities : Array[CityInfo] = []
var med_cities : Array[CityInfo] = []
var hard_cities : Array[CityInfo] = []
var extreme_cities : Array[CityInfo] = []

func _ready():
	var dir = DirAccess.open("res://City Data/")
	var files = dir.get_files()
	
	for file in files:
		file = file.trim_suffix(".remap")
		var loaded_city = load("res://City Data/" + file)
		
		match loaded_city.level_difficulty:
			Enums.LevelDifficulty.EASY:
				easy_cities.append(loaded_city)
			Enums.LevelDifficulty.MEDIUM:
				med_cities.append(loaded_city)
			Enums.LevelDifficulty.HARD:
				hard_cities.append(loaded_city)
			Enums.LevelDifficulty.EXTREME:
				extreme_cities.append(loaded_city)
	
