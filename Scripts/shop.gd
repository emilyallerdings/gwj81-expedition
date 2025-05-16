extends Node3D

#@export var next_scene : PackedScene = null
@onready var selection_menu_ui = $"Selection Menu UI"

var select_map = null

func _ready():
	SoundBus.rolling_suitcase.stop()
	SoundBus.song_3.play()
	
	select_map = GameManager.map_select_loaded
	select_map.reset()
	#add_child(select_map)
	select_map.prev_scene = selection_menu_ui
	select_map.visible = false

func _on_next_pressed():
	SoundBus.button.play()
	selection_menu_ui.visible = false
	select_map.visible = true
