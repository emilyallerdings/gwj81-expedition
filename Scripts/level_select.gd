extends Panel

@onready var button = $VBoxContainer/Button
@onready var button_2 = $VBoxContainer/Button2

var current_level : int = 0
var randnum1 : int = 0
var randnum2 : int = 0

func _ready():
	current_level = GameManager.current_level
	
	if current_level > -1 and current_level <= 2:
		generate_unique_pair(0, 2)
		var option_1 = GameManager.easy_levels[randnum1].instantiate()
		var option_2 = GameManager.easy_levels[randnum2].instantiate()
		button.text = option_1.city_name
		button_2.text = option_2.city_name
	
	#Initialize buttons to display the current level's city and difficulty
	#button.text = GameManager.

func generate_unique_pair(min_num: int, max_num: int):
	randomize()
	randnum1 = randi_range(min_num, max_num)
	var options := []
	for i in range(min_num, max_num):
		options.append(i)
	options.erase(randnum1)
	randnum2 = options[randi() % options.size()]

func _on_button_pressed():
	button_2.disabled = true


func _on_button_2_pressed():
	button.disabled = true
