extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var main_camera: Camera3D = $MainCamera

var playing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
<<<<<<< Updated upstream
<<<<<<< Updated upstream
	SoundBus.song_1.play()
=======
=======
>>>>>>> Stashed changes
	playing = true
	pass # Replace with function body.
>>>>>>> Stashed changes


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	main_camera.global_position.z = $Player.global_position.z - 2.5
	if playing && $Player.global_position.z >= $BoardingRamp.length - 5.0:
		print("you win!")
		playing = false
	pass

# YAY
