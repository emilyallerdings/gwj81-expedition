extends Resource

class_name CityInfo

@export var name : String = ""
@export var airport_code : String = ""

enum LevelDifficulty {
	EASY = 0,
	MEDIUM = 3,
	HARD = 5,
	EXTREME = 8
}

#@export var level_difficulty : Enums.LevelDifficulty
@export var level_difficulty: LevelDifficulty

var modifier_difficulty : int = 0

func roll_modifier():
	modifier_difficulty = randi_range(0, 3)
