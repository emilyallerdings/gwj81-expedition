extends Control

@onready var money = $Panel/Money
@onready var flight_coins_accumulated = $"Panel/FlightCoins Accumulated"
@onready var total_time = $"Panel/Total Time"

func _ready():
	
	money.text = "Money Earned: " + str(GameManager.total_money)

func _on_next_pressed():
	SoundBus.button.play()
	TransitionEffect.transition_to_scene("res://Scenes/shop.tscn")
