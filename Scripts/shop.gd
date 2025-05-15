extends MeshInstance3D


func _ready():
	SoundBus.rolling_suitcase.stop()
	SoundBus.song_3.play()



func _on_next_pressed():
	SoundBus.button.play()
	
