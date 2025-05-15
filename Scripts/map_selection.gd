extends Control

@export var prev_scene : Node3D = null

@onready var trip_start = $"Trip Start"
@onready var back = $Back
@onready var fly = $Fly
@onready var h_box_container = $ScrollContainer/HBoxContainer
@onready var scroll_container = $ScrollContainer

var transition_screen : PackedScene = preload("res://Scenes/transition_screen.tscn")
var map_select : PackedScene = preload("res://Scenes/level_select.tscn")
var level = null

func _ready():
	fly.disabled = true
	trip_start.text = "Trip Start: " + Time.get_date_string_from_system(false)
	
	
	for i in GameManager.max_levels:
		level = map_select.instantiate()
		level.current_level_amount = i
		h_box_container.add_child(level)
		# rebase
		# rebase 2
	
	for child in h_box_container.get_children():
		if child.current_level != GameManager.current_level:
			for button in child.v_box_container.get_children():
				if button is Button:
					button.disabled = true
	
	scroll_container.set_deferred("scroll_horizontal", 340 * GameManager.current_level)

func _process(delta):
	var selected = false
	for child in h_box_container.get_children():
		if child.is_selected:
			selected = true
			break
	fly.disabled = !selected

func _on_back_pressed():
	self.visible = false
	prev_scene.selection_menu_ui.visible = true

func _on_fly_pressed():
	SoundBus.start_game.play()
	SoundBus.airport_ambience.stop()
	SoundBus.song_2.stop()
	TransitionEffect.transition_to_scene("res://Scenes/main.tscn")

#func _on_back_mouse_entered():
	#prev_scene.suitecase_sprite = Vector2(back.position.x - 50.0, back.position.y + 35.0)
#
#func _on_fly_mouse_entered():
	#prev_scene.suitecase_sprite = Vector2(fly.position.x - 50.0, fly.position.y + 35.0)
