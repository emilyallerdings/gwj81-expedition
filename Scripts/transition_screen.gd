extends Control

@onready var current_location = $"Current Location"
@onready var destination = $Destination

var next_scene : PackedScene = preload("res://Scenes/main.tscn")

func _ready():
	if GameManager.current_city == null:
		current_location.text = "Home"
	else:
		current_location.text = GameManager.current_city.name
	destination.text = GameManager.selected_city.name
	
	SoundBus.flyby.play()
	await SoundBus.flyby.finished
	TransitionEffect.transition_to_scene("res://Scenes/main.tscn", GameManager.generation_finished)
