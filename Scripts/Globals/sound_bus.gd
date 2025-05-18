extends Node

signal sounds_loaded

#region sfx
@onready var airport_ambience:AudioStreamPlayer = $"Airport Ambience"
@onready var airplane_landing: AudioStreamPlayer = $"Airplane Landing"
@onready var button:AudioStreamPlayer = $Button
@onready var rolling_suitcase:AudioStreamPlayer = $"Rolling Suitcase"
@onready var button_hover_click:AudioStreamPlayer = $"Button Hover Click"
@onready var whoosh:AudioStreamPlayer = $Whoosh
@onready var start_game:AudioStreamPlayer = $"Start Game"
@onready var flyby:AudioStreamPlayer = $Flyby
@onready var countdown_horn:AudioStreamPlayer = $"Countdown Horn"
@onready var click:AudioStreamPlayer = $Click
@onready var buy:AudioStreamPlayer = $Buy
@onready var ocean_waves:AudioStreamPlayer = $"Ocean Waves"
@onready var wrong: AudioStreamPlayer = $Wrong
@onready var whistle: AudioStreamPlayer = $Whistle
#endregion

#region music
@onready var song_1:AudioStreamPlayer = $Song1
@onready var song_2:AudioStreamPlayer = $Song2
@onready var song_3:AudioStreamPlayer = $Song3
@onready var song_4:AudioStreamPlayer = $Song4

#endregion

func fade_out(sound:AudioStreamPlayer):
	var prev_vol = sound.volume_db
	var tween = create_tween()
	tween.tween_property(sound, "volume_db", -80, 2.0)
	await tween.finished
	sound.stop()
	sound.volume_db = prev_vol

func preload_sounds():
	#var prev = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	await get_tree().create_timer(0.2).timeout
	for child:AudioStreamPlayer in get_children():
		child.play(0)
	await get_tree().process_frame
	await get_tree().create_timer(0.1).timeout
	for child:AudioStreamPlayer in get_children():
		child.stop()
		child.seek(0)
	await get_tree().process_frame
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	sounds_loaded.emit()

func reset_sounds():
	for child in get_children():
		child.stop()
