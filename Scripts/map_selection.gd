extends Control

@export var prev_scene : Node3D = null

@onready var trip_start = $"Trip Start"
@onready var back = $Back
@onready var fly = $Fly
@onready var h_box_container = $ScrollContainer/Panel/HBoxContainer
@onready var scroll_container = $ScrollContainer

var transition_screen : PackedScene = preload("res://Scenes/transition_screen.tscn")
var level_select : PackedScene = preload("res://Scenes/new_level_select2.tscn")
var level = null

func _ready():
	#print(GameManager.current_level)
	prev_scene = get_parent()
	fly.disabled = true
	trip_start.text = "Trip Start: " + Time.get_date_string_from_system(false)
	
	for i in GameManager.max_levels:
		level = level_select.instantiate()
		level.level_selected.connect(level_selected)
		level.current_level = i
		h_box_container.add_child(level)
	
	for level_select in h_box_container.get_children():
		if !level_select is VSeparator:
			if level_select.current_level != GameManager.current_level:
				level_select.set_disable()
	
	scroll_container.set_deferred("scroll_horizontal", 340 * GameManager.current_level)

func _process(delta):
	pass

func level_selected():
	$Fly.disabled = false

func _on_back_pressed():
	SoundBus.button.play()
	self.visible = false
	prev_scene.selection_menu_ui.visible = true
	#if prev_scene.selection_menu_ui:
		#prev_scene.selection_menu_ui.visible = true

func _on_fly_pressed():
	SoundBus.button.play()
	SoundBus.start_game.play()
	SoundBus.airport_ambience.stop()
	SoundBus.song_2.stop()
	SoundBus.song_3.stop()
	TransitionEffect.transition_to_scene("res://Scenes/transition_screen.tscn")

#func _on_back_mouse_entered():
	#prev_scene.suitecase_sprite = Vector2(back.position.x - 50.0, back.position.y + 35.0)
#
#func _on_fly_mouse_entered():
	#prev_scene.suitecase_sprite = Vector2(fly.position.x - 50.0, fly.position.y + 35.0)
