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
@onready var wrong: AudioStreamPlayer = $Wrong

#endregion

#region music
@onready var song_1:AudioStreamPlayer = $Song1
@onready var song_2:AudioStreamPlayer = $Song2
@onready var song_3:AudioStreamPlayer = $Song3

#endregion


func preload_sounds():
	#var prev = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	#AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	for child:AudioStreamPlayer in get_children():
		child.play(0)
	await get_tree().process_frame
	await get_tree().create_timer(0.1).timeout
	for child:AudioStreamPlayer in get_children():
		child.stop()
		child.seek(0)
	await get_tree().process_frame
	#AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), prev)
	sounds_loaded.emit()
