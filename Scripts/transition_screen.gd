extends Control

var next_scene : PackedScene = preload("res://Scenes/main.tscn")

func _ready():
	SoundBus.flyby.play()
	await SoundBus.flyby.finished
	TransitionEffect.transition_to_scene("res://Scenes/main.tscn", GameManager.generation_finished)
