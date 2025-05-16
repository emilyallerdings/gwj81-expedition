extends Node3D

@export var luggages : Array[PackedScene] = [preload("res://Scenes/official_luggage_mainmenu.tscn"), 
preload("res://Scenes/big_daddy_mainmenu.tscn"),
preload("res://Scenes/sparklecorn_mainmenu.tscn"),
preload("res://Scenes/hot_rod_mainmenu.tscn")]
@export var rotation_speed : Vector3 = Vector3(0, 20, 0)

@onready var suitecase_sprite = $SuitecaseSprite

#region menus
@onready var main_menu_camera = $"Main Menu/Main Menu Camera"
@onready var main_menu_ui = $"Main Menu/Main Menu UI"

@onready var options_menu_camera = $"Options Menu/Options Menu Camera"
@onready var options_menu_ui = $"Options Menu/Options Menu UI"

@onready var selection_menu_camera = $"Selection Menu/Selection Menu Camera"
@onready var selection_menu_ui = $"Selection Menu/Selection Menu UI"

@onready var credits_menu_camera = $"Credits Menu/Credits Menu Camera"
@onready var credits_menu_ui = $"Credits Menu/Credits Menu UI"
#endregion

#region main menu ui buttons
@onready var play = $"Main Menu/Main Menu UI/Play"
@onready var options = $"Main Menu/Main Menu UI/Options"
@onready var credits = $"Main Menu/Main Menu UI/Credits"
#endregion

#region options menu ui buttons
@onready var options_back = $"Options Menu/Options Menu UI/Options Back"
#endregion

#region credits menu ui buttons
@onready var credits_back = $"Credits Menu/Credits Menu UI/Credits Back"
#endregion

#region selection menu ui buttons
@onready var selection_back = $"Selection Menu/Selection Menu UI/Selection Back"
@onready var right_button = $"Selection Menu/Selection Menu UI/Right Button"
@onready var left_button = $"Selection Menu/Selection Menu UI/Left Button"
@onready var selection_play = $"Selection Menu/Selection Menu UI/Selection Play"
@onready var luggage_type = $"Selection Menu/Selection Menu UI/Panel2/Luggage Type"
@onready var luggage_stats = $"Selection Menu/Selection Menu UI/Luggage Stats"
@onready var luggage_description = $"Selection Menu/Selection Menu UI/Panel/Luggage Description"
#endregion

@onready var selection_stage = $SelectionStage

var camera_transition := false
var transition_speed := 5.0
var from_camera : Camera3D = null
var to_camera : Camera3D = null

var i : int = 0
var current_luggage_type = luggages[i].instantiate()
#var next_scene : PackedScene = preload("res://Scenes/map_selection.tscn")
var select_map = null

func _ready() -> void:
	
	TransitionEffect.current_scene = self
	SoundBus.airport_ambience.play()
	SoundBus.song_2.play()
	main_menu_ui.visible = true
	options_menu_ui.visible = false
	selection_menu_ui.visible = false
	credits_menu_ui.visible = false
	
	update_luggage_object()
	select_map = GameManager.map_select_loaded
	select_map.reset()
	select_map.prev_scene = selection_menu_ui
	#add_child(select_map)
	select_map.visible = false
	suitecase_sprite.position = Vector2(play.position.x - 50.0, play.position.y + 35.0)
	

func _process(delta: float) -> void:
	selection_stage.rotation_degrees += rotation_speed * delta
	lerp_camera(delta)

func lerp_camera(_delta: float) -> void:
	
	if camera_transition:
		#var cam_transition = get_tree().create_tween()
		#cam_transition.tween_property(to_camera, "current", true, 0.5)
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

func update_luggage_object():
	current_luggage_type = luggages[i].instantiate()
	if selection_stage.get_children():
		selection_stage.get_child(0).queue_free()
	selection_stage.add_child(current_luggage_type)
	luggage_type.text = current_luggage_type.title
	luggage_type.add_theme_font_override("normal_font", current_luggage_type.font)
	luggage_stats.text = "Top Speed: " \
	+ str(current_luggage_type.top_speed) + "\nHandling: " \
	+ str(current_luggage_type.handling) + "\nBoost: " \
	+ str(current_luggage_type.boost)
	luggage_description.text = current_luggage_type.description
	for child in current_luggage_type.get_children():
		if child is GPUParticles3D:
			child.visible = false
	#selection_stage.add_child(current_luggage_type)
	GameManager.chosen_luggage = luggages[i]

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
	SoundBus.whoosh.play()
	transition_cameras(main_menu_camera, credits_menu_camera)
	main_menu_ui.visible = false
	credits_menu_ui.visible = true

func _on_credits_back_pressed():
	SoundBus.button.play()
	SoundBus.whoosh.play()
	transition_cameras(credits_menu_camera, main_menu_camera)
	main_menu_ui.visible = true
	credits_menu_ui.visible = false

func _on_selection_play_pressed():
	SoundBus.button.play()
	SoundBus.whoosh.play()
	selection_menu_ui.visible = false
	select_map.visible = true

func _on_right_button_pressed():
	SoundBus.button.play()
	i = (i + 1) % len(luggages)
	update_luggage_object()

func _on_left_button_pressed():
	SoundBus.button.play()
	i = (i - 1) % len(luggages)
	update_luggage_object()
	
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

func _on_credits_back_mouse_entered():
	suitecase_sprite.position = Vector2(credits_back.position.x - 50.0, credits_back.position.y + 35.0)
	SoundBus.button_hover_click.play()
#endregion
