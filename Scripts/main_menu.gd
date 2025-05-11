extends Node3D

@onready var suitecase_sprite = $SuitecaseSprite

#region menus
@onready var main_menu_camera = $"Main Menu/Main Menu Camera"
@onready var main_menu_ui = $"Main Menu/Main Menu UI"

@onready var options_menu_camera = $"Options Menu/Options Menu Camera"
@onready var options_menu_ui = $"Options Menu/Options Menu UI"

@onready var selection_menu_camera = $"Selection Menu/Selection Menu Camera"
@onready var selection_menu_ui = $"Selection Menu/Selection Menu UI"

#endregion

#region main menu ui buttons
@onready var play = $"Main Menu/Main Menu UI/Play"
@onready var options = $"Main Menu/Main Menu UI/Options"
@onready var credits = $"Main Menu/Main Menu UI/Credits"
#endregion

#region options menu ui buttons
@onready var options_back = $"Options Menu/Options Menu UI/Options Back"
#endregion

#region selection menu ui buttons

#endregion

var camera_transition := false
var transition_speed := 5.0
var from_camera : Camera3D = null
var to_camera : Camera3D = null

func _ready() -> void:
	SoundBus.airport_ambience.play()
	main_menu_ui.visible = true
	options_menu_ui.visible = false
	suitecase_sprite.position = Vector2(play.position.x - 50.0, play.position.y + 35.0)

func _process(delta: float) -> void:
	lerp_camera(delta)
	pass

func lerp_camera(delta: float) -> void:
	
	if camera_transition:
		to_camera.make_current()
		from_camera.clear_current()
		
		#TODO Tween the behavior
		# no idea how to make the camera switch smooth
		#from_camera.position.slerp(to_camera.position, transition_speed)
		#from_camera.rotation.slerp(to_camera.rotation, transition_speed)
		camera_transition = false

func transition_cameras(curr_camera: Camera3D, next_camera: Camera3D) -> void:
	from_camera = curr_camera
	to_camera = next_camera
	
	camera_transition = true
	
func _on_play_pressed() -> void:
	SoundBus.button.play()
	SoundBus.whoosh.play()
	transition_cameras(main_menu_camera, selection_menu_camera)
	
	selection_menu_ui.visible = true
	await get_tree().create_timer(0.5)
	main_menu_ui.visible = false

func _on_options_pressed() -> void:
	SoundBus.button.play()
	SoundBus.whoosh.play()
	transition_cameras(main_menu_camera, options_menu_camera)
	
	main_menu_ui.visible = false
	await get_tree().create_timer(0.5)
	options_menu_ui.visible = true
	suitecase_sprite.position = Vector2(options_back.position.x - 50.0, options_back.position.y + 35.0)

func _on_options_back_pressed():
	SoundBus.button.play()
	SoundBus.whoosh.play()
	transition_cameras(options_menu_camera, main_menu_camera)
	
	options_menu_ui.visible = false
	await get_tree().create_timer(0.5)
	main_menu_ui.visible = true
	suitecase_sprite.position = Vector2(options.position.x - 50.0, options.position.y + 35.0)

func _on_credits_pressed() -> void:
	SoundBus.button.play()

func _on_play_mouse_entered() -> void:
	suitecase_sprite.position = Vector2(play.position.x - 50.0, play.position.y + 35.0)
	SoundBus.button_hover_click.play()

func _on_options_mouse_entered() -> void:
	suitecase_sprite.position = Vector2(options.position.x - 50.0, options.position.y + 35.0)
	SoundBus.button_hover_click.play()

func _on_credits_mouse_entered() -> void:
	suitecase_sprite.position = Vector2(credits.position.x - 50.0, credits.position.y + 35.0)
	SoundBus.button_hover_click.play()

func _on_options_back_mouse_entered() -> void:
	SoundBus.button_hover_click.play()
	suitecase_sprite.position = Vector2(options_back.position.x - 50.0, options_back.position.y + 35.0)
