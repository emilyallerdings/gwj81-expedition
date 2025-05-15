extends Resource

class_name CityInfo

@export var name : String = ""
@export var airport_code : String = ""
@export var level_difficulty : Enums.LevelDifficulty

var modifier_difficulty : int = 0

func roll_modifier():
	modifier_difficulty = randi_range(0, 3)
