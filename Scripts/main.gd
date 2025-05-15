extends Node3D

@onready var boarding_generator: Node3D = $BoardingGenerator

@onready var player: CharacterBody3D = %Player
@onready var main_camera: Camera3D = $MainCameraAnchor/MainCamera
#@onready var speed_lines = $"MainCamera/Speed Lines"
@onready var main_camera_anchor: Node3D = $MainCameraAnchor

#@onready var speed_tweener := get_tree().create_tween().set_loops()
#var shader_material : ShaderMaterial = preload("res://Assets/speed_lines_material.tres")

@export var starting_z:float = 10.0
@export var difficulty:float = 8.0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	#ready_stage()
	await get_tree().create_timer(0.01).timeout
	boarding_generator.randomize_seed()
	boarding_generator.generate()
	
	await boarding_generator.finished_generation
	boarding_generator.connect("player_left_turn", turn_player_left)
	boarding_generator.connect("player_right_turn", turn_player_right)
	boarding_generator.connect("player_finished", player_finished)
	start_game()
	main_camera.fov = 90.0

	
#func initialize_player() -> void:
	#var player = self.get_node("Player")
	#player.collision_shape = player.get_child(3).get_child(5)
	
func start_game():
	
	SoundBus.song_1.play()
	player.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_forward_vec = project_vector(player.velocity, player.forward_direction)
	$"FPS Counter/FPSLabel".text = "FPS: " + str(Engine.get_frames_per_second())
	var str = "%.2f"
	var speed = player_forward_vec.length()
	#print($Player.velocity)
	str = (str % speed)
	$Speed/SpeedLabel.text = "Speed: " + str + "m/s"
	main_camera_anchor.global_position.z = player.global_position.z
	main_camera_anchor.global_position.x = player.global_position.x

	
	if player.forward_speed > player.max_speed + (player.boost_bonus / 2):
		var camera_increase := get_tree().create_tween()
		camera_increase.tween_property(main_camera, "fov", 110.0, 0.25)
		
	else:
		var camera_increase := get_tree().create_tween()
		camera_increase.tween_property(main_camera, "fov", 90.0, 0.25)
		
	pass

#func start_speed_lines() -> void:
	#speed_tweener.tween_property(shader_material, "shader_parameter/sample_radius", 1.0, 0.5).as_relative()
	#speed_tweener.tween_property(shader_material, "shader_parameter/sample_radius", 0.0, 0.5).as_relative()
# YAY

func project_vector(a: Vector3, b: Vector3) -> Vector3:
	var dot_product = a.dot(b)
	var b_magnitude_squared = b.length_squared()
	if b_magnitude_squared == 0:
		return Vector3.ZERO  # Avoid division by zero
	return (dot_product / b_magnitude_squared) * b

func _on_obstacle_body_entered(body: Node3D) -> void:
	if body == player:
		player.on_hit_obstacle()
		
	pass # Replace with function body.

func turn_player_right():

	$Player.forward_direction = $Player.forward_direction.rotated(Vector3.UP, deg_to_rad(90))
	#print($Player.forward_direction)
	rotate_cam_smooth(90)
	return
	
func turn_player_left():
	$Player.forward_direction = $Player.forward_direction.rotated(Vector3.UP, deg_to_rad(-90))
	rotate_cam_smooth(-90)
	#print($Player.forward_direction)
	return

func rotate_cam_smooth(degrees:float):
	var target_rotation = main_camera_anchor.rotation_degrees.y + degrees
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		main_camera_anchor, 
		"rotation_degrees:y", 
		target_rotation, 
		0.2,  # Duration (fast but smooth)
	)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

func player_finished():
	print("player_finishedd")
	player.finish()
