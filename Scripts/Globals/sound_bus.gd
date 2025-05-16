extends Node

signal sounds_loaded

#region sfx
@onready var airport_ambience = $"Airport Ambience"
@onready var button = $Button
@onready var rolling_suitcase = $"Rolling Suitcase"
@onready var button_hover_click = $"Button Hover Click"
@onready var whoosh = $Whoosh
@onready var start_game = $"Start Game"
@onready var flyby = $Flyby
@onready var countdown_horn = $"Countdown Horn"

#endregion

#region music
@onready var song_1 = $Song1
@onready var song_2 = $Song2
@onready var song_3 = $Song3

#endregion


func preload_sounds():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
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
