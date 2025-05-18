extends Node

var path:String = "res://Patterns/"
const test_path:String = "res://Patterns/"
const OBSTACLE = preload("res://Scenes/obstacle.tscn")
const PICKUP = preload("res://Scenes/pickup.tscn")
const CRATE = preload("res://Scenes/obstacle_crate.tscn")
var easy_patterns = []
var med_patterns = []
var hard_patterns = []

func _ready() -> void:
	var dir = DirAccess.open(path)
	var files = dir.get_files()
	
	var found = false
	
	match found:
		true: queue_free()
	
	for file in files:
		file = file.trim_suffix(".remap")
		var loaded_pattern = load(path + file)
		if loaded_pattern.difficulty == Enums.PatternDifficulty.EASY:
			easy_patterns.append(loaded_pattern)
		elif loaded_pattern.difficulty == Enums.PatternDifficulty.MED:
			med_patterns.append(loaded_pattern)
		else: 
			hard_patterns.append(loaded_pattern)
			
func get_pattern_by_diff(diff, remaining_distance, prev_pattern):
		if diff == Enums.PatternDifficulty.EASY:
			return get_random_pattern_from_arr(easy_patterns, remaining_distance, prev_pattern)
		elif diff == Enums.PatternDifficulty.MED:
			return get_random_pattern_from_arr(med_patterns, remaining_distance, prev_pattern)
		else: 
			return get_random_pattern_from_arr(hard_patterns, remaining_distance, prev_pattern)

func get_random_pattern_from_arr(arr:Array, remaining_distance, prev_pattern):
	var dup_arr = arr.duplicate()
	while dup_arr.size() > 0:
		var rand = dup_arr.pick_random()
		if rand.length <= remaining_distance && rand != prev_pattern:
			return rand
		dup_arr.erase(rand)
	return null
