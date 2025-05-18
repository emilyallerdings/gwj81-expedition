extends Control

@onready var music_volume : HSlider = $"Options Holder/Music Volume"
@onready var sfx_volume : HSlider = $"Options Holder/SFX Volume"

var default_val : float = 0.5

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(default_val))
	sfx_volume.value = default_val
	music_volume.value = default_val

func _on_sfx_volume_value_changed(value):
	var idx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(idx, linear_to_db(sfx_volume.value))

func _on_music_volume_value_changed(value):
	var idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(idx, linear_to_db(music_volume.value))
