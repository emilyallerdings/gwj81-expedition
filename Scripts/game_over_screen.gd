extends Node3D

func _ready() -> void:
	$"Game Over UI/Try Again".disabled = false
	$"Game Over UI/Quit".disabled = false
	SoundBus.rolling_suitcase.stop()
	GameManager.reset()
	

func _on_quit_pressed():
	$"Game Over UI/Quit".disabled = true
	get_tree().quit()


func _on_try_again_pressed():
	#TODO RESET ALL VARIABLES IN GAME MANAGER
	#how do i go back to the loading screen
	$"Game Over UI/Try Again".disabled = true
	TransitionEffect.transition_to_scene("res://Scenes/main_menu.tscn")
