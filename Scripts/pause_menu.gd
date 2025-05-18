extends Control

@onready var sfx_volume = $"SFX Volume"
@onready var music_volume = $"Music Volume"

func _ready():
	sfx_volume.value = GameManager.sfx_db
	music_volume.value = GameManager.music_db

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		unpause()

func _on_resume_pressed():
	unpause()

func unpause():
	get_tree().paused = false
	queue_free()

func _on_main_menu_pressed():
	unpause()
	SoundBus.reset_sounds()
	SoundBus.rolling_suitcase.stop()
	TransitionEffect.transition_to_scene("res://Scenes/main_menu.tscn")


func _on_sfx_volume_value_changed(value):
	GameManager.sfx_db = sfx_volume.value
	var idx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(idx, linear_to_db(sfx_volume.value))

func _on_music_volume_value_changed(value):
	GameManager.music_db = music_volume.value
	var idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(idx, linear_to_db(music_volume.value))
