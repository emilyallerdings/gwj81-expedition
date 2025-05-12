extends Control

@export var prev_scene : Node3D = null

@onready var trip_start = $"Trip Start"
@onready var back = $Back
@onready var fly = $Fly

var next_scene : PackedScene = preload("res://Scenes/main.tscn")

func _ready():
	trip_start.text = "Trip Start: " + Time.get_date_string_from_system(false)

func _on_back_pressed():
	self.visible = false
	prev_scene.selection_menu_ui.visible = true

func _on_fly_pressed():
	SoundBus.start_game.play()
	SoundBus.airport_ambience.stop()
	SoundBus.song_2.stop()
	get_tree().change_scene_to_packed(next_scene)

#func _on_back_mouse_entered():
	#prev_scene.suitecase_sprite = Vector2(back.position.x - 50.0, back.position.y + 35.0)
#
#func _on_fly_mouse_entered():
	#prev_scene.suitecase_sprite = Vector2(fly.position.x - 50.0, fly.position.y + 35.0)
