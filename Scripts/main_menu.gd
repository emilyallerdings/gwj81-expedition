extends Node3D

#region menus
@onready var main_menu_ui = $"Main Menu UI"
@onready var main_menu_camera = $"Main Menu Camera"
@onready var options_menu_camera = $"Options Menu/Options Menu Camera"
#endregion

@onready var play = $"Main Menu UI/Play"
@onready var options = $"Main Menu UI/Options"
@onready var credits = $"Main Menu UI/Credits"
@onready var suitecase_sprite = $"Main Menu UI/SuitecaseSprite"

var is_lerping_to_options := false
var transition_speed := 5.0

func _ready() -> void:
	SoundBus.airport_ambience.play()
	suitecase_sprite.position = Vector2(play.position.x - 50.0, play.position.y + 35.0)

func _process(delta: float) -> void:
	lerp_camera(delta)

func lerp_camera(delta: float) -> void:
	if is_lerping_to_options and main_menu_camera:
		# Interpolate position
		var target_pos = options_menu_camera.global_transform.origin
		var new_pos = main_menu_camera.global_transform.origin.lerp(target_pos, delta * transition_speed)  # adjust speed

		# Interpolate rotation (using basis slerp)
		var target_basis = options_menu_camera.global_transform.basis
		var new_basis = main_menu_camera.global_transform.basis.slerp(target_basis, delta * transition_speed)

		# Apply new transform
		main_menu_camera.global_transform = Transform3D(new_basis, new_pos)

		# Stop lerping when close enough
		if main_menu_camera.global_transform.origin.distance_to(target_pos) < 0.1:
			is_lerping_to_options = false
			options_menu_camera.make_current()

func _on_play_pressed() -> void:
	SoundBus.button.play()

func _on_options_pressed() -> void:
	SoundBus.button.play()
	is_lerping_to_options = true

func _on_credits_pressed() -> void:
	SoundBus.button.play()

func _on_play_mouse_entered() -> void:
	print(play.position)
	suitecase_sprite.position = Vector2(play.position.x - 50.0, play.position.y + 35.0)

func _on_options_mouse_entered() -> void:
	suitecase_sprite.position = Vector2(options.position.x - 50.0, options.position.y + 35.0)

func _on_credits_mouse_entered() -> void:
	suitecase_sprite.position = Vector2(credits.position.x - 50.0, credits.position.y + 35.0)
