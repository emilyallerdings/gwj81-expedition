extends Node3D

func _ready() -> void:
	SoundBus.rolling_suitcase.stop()

func _on_quit_pressed():
	get_tree().quit()


func _on_try_again_pressed():
	#TODO RESET ALL VARIABLES IN GAME MANAGER
	#how do i go back to the loading screen
	TransitionEffect.transition_to_scene("res://Scenes/main_menu.tscn")
