extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var main_camera: Camera3D = $MainCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	main_camera.global_position.z = $Player.global_position.z - 2.5
	pass

# YAY
