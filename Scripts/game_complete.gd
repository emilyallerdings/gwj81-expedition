extends Node3D

@onready var luggage_placement = $"Luggage Placement"
@onready var quit = $Control/Quit
@onready var main_menu = $"Control/Main Menu"

func _ready():
	
	$"Control/Total Money".text += GameManager.cents_to_str(GameManager.total_total_money)
	$"Control/Total Time".text += ("%.2f" % GameManager.total_total_time) + "s"
	
	SoundBus.ocean_waves.play()
	SoundBus.song_4.play()
	
	var luggage = GameManager.chosen_luggage.instantiate()
	luggage_placement.add_child(luggage)
	luggage.global_transform = luggage_placement.global_transform
	for child in luggage.get_children():
		if child is GPUParticles3D:
			child.visible = false
	


func _on_quit_pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	SoundBus.reset_sounds()
	TransitionEffect.transition_to_scene("res://Scenes/main_menu.tscn")
