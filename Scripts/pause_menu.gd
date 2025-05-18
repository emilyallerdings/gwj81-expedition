extends Control


func _input(event):
	if Input.is_action_just_pressed("pause"):
		unpause()

func _on_resume_pressed():
	unpause()

func unpause():
	get_tree().paused = false
	queue_free()
