extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var main_camera: Camera3D = $MainCamera
#@onready var speed_lines = $"MainCamera/Speed Lines"

#@onready var speed_tweener := get_tree().create_tween().set_loops()
#var shader_material : ShaderMaterial = preload("res://Assets/speed_lines_material.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundBus.song_1.play()
	#start_speed_lines()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	main_camera.global_position.z = $Player.global_position.z - 2.5
	pass

#func start_speed_lines() -> void:
	#speed_tweener.tween_property(shader_material, "shader_parameter/sample_radius", 1.0, 0.5).as_relative()
	#speed_tweener.tween_property(shader_material, "shader_parameter/sample_radius", 0.0, 0.5).as_relative()
# YAY
