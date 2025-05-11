extends Node3D

@onready var play = $"Main Menu UI/Play"
@onready var options = $"Main Menu UI/Options"
@onready var credits = $"Main Menu UI/Credits"
@onready var suitecase_sprite = $SuitecaseSprite

func _ready():
	SoundBus.airport_ambience.play()


func _on_play_pressed():
	SoundBus.button.play()

func _on_options_pressed():
	SoundBus.button.play()

func _on_credits_pressed():
	SoundBus.button.play()

func _on_play_mouse_entered():
	suitecase_sprite.position = play.position + Vector2(-5.0, play.position.y)

func _on_options_mouse_entered():
	suitecase_sprite.position = options.position + Vector2(-5.0, options.position.y)

func _on_credits_mouse_entered():
	suitecase_sprite.position = credits.position + Vector2(-5.0, credits.position.y)
