extends Node3D

@onready var luggage_placement = $"Luggage Placement"

func _ready():
	SoundBus.ocean_waves.play()
	SoundBus.song_4.play()
	
	var luggage = GameManager.chosen_luggage.instantiate()
	luggage_placement.add_child(luggage)
	luggage.global_transform = luggage_placement.global_transform
	for child in luggage.get_children():
		if child is GPUParticles3D:
			child.visible = false
	
