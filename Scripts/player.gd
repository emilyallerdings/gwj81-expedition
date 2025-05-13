extends CharacterBody3D

@export var max_speed:float = 10.0
var forward_speed: float = 0.0


@export var turn_speed: float = 2.0
@export var max_turn_angle: float = 30.0
@export var smooth_factor: float = 0.1
@export var turn_slowdown_factor: float = 0.005

@export var luggage : PackedScene = null
#@onready var luggage: Node3D = $luggage

@export var blink_interval: float = 0.1
@export var blink_duration: float = 1.0
@export var blink_intensity: float = 0.7
@export var shader_material: ShaderMaterial

var forward_direction: Vector3 = Vector3(0,0,1)
var target_velocity: Vector3 = Vector3.ZERO

var boost_accel := 0.1
var boost_bonus := 10.0

var blinking = false
var elapsed_time = 0.0
var all_materials = {}
var luggage_object = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	luggage = GameManager.chosen_luggage
	luggage_object = luggage.instantiate()
	luggage_object.scale = Vector3(1, 1, 1)
	self.add_child(luggage_object)

	# Apply the shared shader material to all mesh surfaces in the group
	#for child in luggage_object.get_children():
		#if child is MeshInstance3D and child.mesh:
			#var mesh = child.mesh
			#for surface in mesh.get_surface_count():
				#var original_material = mesh.surface_get_material(surface)
				#if original_material:
					#all_materials[original_material] = original_material.albedo_color
			#for surface in child.get_surface_override_material_count():
				#var override_mat = child.get_surface_override_material(surface)
				#if override_mat:
					#all_materials[override_mat] = override_mat.albedo_color
	#print(all_materials.size())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if blinking:
		elapsed_time += delta
		if elapsed_time >= blink_duration:
			blinking = false
			for mat in all_materials.keys():
				mat.albedo_color = all_materials[mat]
			return

		var blink_state = elapsed_time * (PI / blink_interval)
		var max_value = 0.8
		var min_value = 0.0
		var value = min_value + (max_value - min_value) * (1 + sin(blink_state)) / 2

		for mat in all_materials:
			mat.albedo_color = mix_colors(all_materials[mat], Color.RED, value)


func _physics_process(delta: float) -> void:
	
	var is_max_speed = is_equal_approx(forward_speed, max_speed)
	
	if !is_max_speed && forward_speed < max_speed:
		forward_speed = lerp(forward_speed, max_speed, 0.1)

		print(forward_speed)
	if Input.is_action_pressed("boost") && forward_speed >= max_speed * 0.99:
		forward_speed = lerp(forward_speed, max_speed + boost_bonus, boost_accel)
	else:
		forward_speed = lerp(forward_speed, max_speed, 0.5)

	#if not is_on_floor():
		#velocity.y += -9.81 * delta
	# Always move forward
	forward_direction = transform.basis.z

	# Get input for turning
	var input_direction: float = Input.get_axis("right", "left")

	# Calculate target angle and lerp for smooth rotation
	var target_rotation: float = deg_to_rad(max_turn_angle * input_direction)
	var current_rotation: float = lerp_angle(rotation.y, target_rotation, smooth_factor)

	

	# Smoothly rotate the luggage
	rotation.y = current_rotation
	
	# Calculate the turning intensity based on the actual current rotation
	var turning_intensity: float = abs(target_rotation - rotation.y) / deg_to_rad(max_turn_angle)

	# Adjust speed based on the actual rotation intensity (more turn = slower)
	var speed_modifier: float = 1.0 - (turning_intensity * turn_slowdown_factor)
	var current_speed: float = forward_speed * speed_modifier

	# Calculate forward movement
	target_velocity = forward_direction * current_speed

	# Calculate lateral movement based on rotation
	var strafe: Vector3 = transform.basis.x * (input_direction * turn_speed * turning_intensity)


	# Combine forward and strafe motion
	target_velocity += strafe

	# Smooth velocity adjustment
	velocity = lerp(velocity, target_velocity, smooth_factor)
	#print(velocity.length())

	# Move the luggage
	play_rolling()
	move_and_slide()

func play_rolling():
	if velocity.length() > 0.1:
		if not SoundBus.rolling_suitcase.playing:
			SoundBus.rolling_suitcase.play()
	else:
		SoundBus.rolling_suitcase.stop()

func on_hit_obstacle():
	print("ON HIT")
	velocity.z = -30
	forward_speed = -30
	start_blinking()

func start_blinking():
	blinking = true
	elapsed_time = 0.0

func set_material_blink(intensity: float, alpha: float):
	if shader_material:
		shader_material.set("shader_parameter/blink_intensity", intensity)
		shader_material.set("shader_parameter/alpha", alpha)

func mix_colors(color1: Color, color2: Color, factor: float) -> Color:
	return color1.lerp(color2, factor)
	
func start():
	process_mode = Node.PROCESS_MODE_ALWAYS
