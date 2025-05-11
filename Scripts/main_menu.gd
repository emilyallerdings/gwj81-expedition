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
@onready var selection_back = $"Selection Menu/Selection Menu UI/Selection Back"
@onready var right_button = $"Selection Menu/Selection Menu UI/Right Button"
@onready var left_button = $"Selection Menu/Selection Menu UI/Left Button"
@onready var selection_play = $"Selection Menu/Selection Menu UI/Selection Play"
@onready var luggage_type = $"Selection Menu/Selection Menu UI/Luggage Type"
@onready var luggage_stats = $"Selection Menu/Selection Menu UI/Luggage Stats"
#endregion

@onready var selection_stage = $SelectionStage

var camera_transition := false
var transition_speed := 5.0
var from_camera : Camera3D = null
var to_camera : Camera3D = null

var luggages : Array[PackedScene] = [preload("res://Scenes/luggage.tscn"), preload("res://Scenes/selection_test_luggage.tscn")]
var i : int = 0
var current_luggage_type = luggages[i].instantiate()

func _ready() -> void:
	SoundBus.airport_ambience.play()
	SoundBus.song_2.play()
	main_menu_ui.visible = true
	options_menu_ui.visible = false
	selection_menu_ui.visible = false
	luggage_type.text = current_luggage_type.title
	luggage_stats.text = "[color=cyan]Speed: " \
	+ str(current_luggage_type.speed) + "\nHandling: " \
	+ str(current_luggage_type.handling) + "\nBoost: " \
	+ str(current_luggage_type.boost) + "[/color]"
	suitecase_sprite.position = Vector2(play.position.x - 50.0, play.position.y + 35.0)
	selection_stage.add_child(luggages[0].instantiate())

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

#region button press logic
func _on_play_pressed() -> void:
	SoundBus.button.play()
	SoundBus.whoosh.play()
	transition_cameras(main_menu_camera, selection_menu_camera)
	
	selection_menu_ui.visible = true
	#await get_tree().create_timer(0.5).timeout
	main_menu_ui.visible = false
	suitecase_sprite.position = Vector2(selection_back.position.x - 50.0, selection_back.position.y + 35.0)

func _on_options_pressed() -> void:
	SoundBus.button.play()
	SoundBus.whoosh.play()
	transition_cameras(main_menu_camera, options_menu_camera)
	
	main_menu_ui.visible = false
	#await get_tree().create_timer(0.5).timeout
	options_menu_ui.visible = true
	suitecase_sprite.position = Vector2(options_back.position.x - 50.0, options_back.position.y + 35.0)

func _on_options_back_pressed():
	SoundBus.button.play()
	SoundBus.whoosh.play()
	transition_cameras(options_menu_camera, main_menu_camera)
	
	options_menu_ui.visible = false
	#await get_tree().create_timer(0.5).timeout
	main_menu_ui.visible = true
	suitecase_sprite.position = Vector2(options.position.x - 50.0, options.position.y + 35.0)

func _on_selection_back_pressed():
	SoundBus.button.play()
	SoundBus.whoosh.play()
	
	transition_cameras(selection_menu_camera, main_menu_camera)
	
	selection_menu_ui.visible = false
	#await get_tree().create_timer(0.5).timeout
	main_menu_ui.visible = true
	suitecase_sprite.position = Vector2(play.position.x - 50.0, play.position.y + 35.0)

func _on_credits_pressed() -> void:
	SoundBus.button.play()

func _on_selection_play_pressed():
	SoundBus.button.play()
	SoundBus.whoosh.play()

#endregion


#region mouse hover logic
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
	suitecase_sprite.position = Vector2(options_back.position.x - 50.0, options_back.position.y + 35.0)
	SoundBus.button_hover_click.play()

func _on_selection_back_mouse_entered():
	suitecase_sprite.position = Vector2(selection_back.position.x - 50.0, selection_back.position.y + 35.0)
	SoundBus.button_hover_click.play()

func _on_selection_play_mouse_entered():
	suitecase_sprite.position = Vector2(selection_play.position.x - 50.0, selection_play.position.y + 35.0)
	SoundBus.button_hover_click.play()
#endregion


func _on_right_button_pressed():
	SoundBus.button.play()
	i = (i + 1) % len(luggages)
	var luggage = luggages[i].instantiate()
	selection_stage.get_child(0).queue_free()
	selection_stage.add_child(luggage)
	luggage_type.text = luggage.title
	luggage_stats.text = "[color=cyan]Speed: " \
	+ str(luggage.speed) + "\nHandling: " \
	+ str(luggage.handling) + "\nBoost: " \
	+ str(luggage.boost) + "[/color]"
	
func _on_left_button_pressed():
	SoundBus.button.play()
	i = (i - 1) % len(luggages)
	var luggage = luggages[i].instantiate()
	selection_stage.get_child(0).queue_free()
	selection_stage.add_child(luggage)
	luggage_type.text = luggage.title
	luggage_stats.text = "[color=cyan]Speed: " \
	+ str(luggage.speed) + "\nHandling: " \
	+ str(luggage.handling) + "\nBoost: " \
	+ str(luggage.boost) + "[/color]"
