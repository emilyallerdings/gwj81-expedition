extends Node3D


func _ready():
	SoundBus.airport_ambience.play()


func _on_play_pressed():
	SoundBus.button.play()

func _on_options_pressed():
	SoundBus.button.play()

func _on_credits_pressed():
	SoundBus.button.play()
