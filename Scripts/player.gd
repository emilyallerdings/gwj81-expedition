extends CharacterBody3D


@export var forward_speed: float = 10.0
@export var turn_speed: float = 2.0
@export var max_turn_angle: float = 30.0
@export var smooth_factor: float = 0.1
@export var turn_slowdown_factor: float = 0.005

var forward_direction: Vector3 = Vector3(0,0,1)
var target_velocity: Vector3 = Vector3.ZERO
var speed_threshold: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Always move forward
	if not is_on_floor():
		velocity.y += -9.81 * delta
	
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
	#print(velocity)
	
	# TODO implement aligning to track
	
	# Move the luggage
	play_wheel_sound()
	move_and_slide()

func play_wheel_sound() -> void:
	if velocity.length() > speed_threshold:
		if not SoundBus.rolling_suitcase.playing:
			SoundBus.rolling_suitcase.play()
	else:
		if SoundBus.rolling_suitcase.playing:
			SoundBus.rolling_suitcase.stop()
