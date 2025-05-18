extends Control


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		unpause()

func _on_resume_pressed():
	unpause()

func unpause():
	get_tree().paused = false
	queue_free()

func _on_main_menu_pressed():
	unpause()
	SoundBus.song_1.stop()
	SoundBus.rolling_suitcase.stop()
	TransitionEffect.transition_to_scene("res://Scenes/main_menu.tscn")
